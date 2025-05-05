import 'dotenv/config';
import Fastify from 'fastify';
import websocketPlugin from '@fastify/websocket';
import mqtt from 'mqtt';
import { handleDataLogging } from './lib/mqtt';
import { db } from './lib/db';
import { logsTable } from './schema';
import { desc, eq, or } from 'drizzle-orm';
import type {
	DeviceErrorCode,
	DeviceWarningCode,
	ErrorPayload,
	WarningPayload,
} from './interfaces';
import { DataProcessor } from './lib/dataProcessor';
import { handleIssueLogging } from './lib/issue';

/**
 * Fastify initialiaztions
 */

const fastify = Fastify({ logger: true });

fastify.register(websocketPlugin);

// Rudimentary authorization (only HMI will connect anyway)
fastify.addHook('onRequest', async (request, reply) => {
	if (request.headers.authorization !== process.env.SECRET_KEY) {
		reply.code(401).send({ error: 'Unauthorized' });
	}
});

/**
 * MQTT initializations
 */

const username = process.env.MQTT_USERNAME;
const password = process.env.MQTT_PASSWORD;

const mqttClient = await mqtt.connectAsync(process.env.MQTT_URL!, {
	clientId: `backend-${Math.random().toString(16).slice(2, 8)}`,
	clean: true,
	connectTimeout: 4000, // 4 seconds
	reconnectPeriod: 1000, // 1 second
	username,
	password,
	rejectUnauthorized: false,
});

mqttClient.on('connect', async () => {
	console.log('MQTT connected');
});

mqttClient.on('error', error => {
	console.log(`Error connecting to MQTT: ${error}`);
});

/**
 * Data Processing
 */

const dataProcessor = new DataProcessor();

dataProcessor.on('error', async payload => {
	await handleIssueLogging(payload);
});

dataProcessor.on('warning', async payload => {
	await handleIssueLogging(payload);
});

/**
 * Fastify routes
 */

fastify.register(async fastify => {
	fastify.get('/ws', { websocket: true }, (connection, _) => {
		fastify.log.info('Websocket client connected');

		const mqttMessageHandler = (_: string, message: Buffer) => {
			connection.send(message.toString());
		};

		const errorHandler = (payload: ErrorPayload<DeviceErrorCode>) => {
			connection.send(JSON.stringify(payload));
		};

		const warningHandler = (payload: WarningPayload<DeviceWarningCode>) => {
			connection.send(JSON.stringify(payload));
		};

		mqttClient.on('message', mqttMessageHandler);
		dataProcessor.on('error', errorHandler);
		dataProcessor.on('warning', warningHandler);

		connection.on('message', async message => {
			const msg = message.toString();

			if (msg === 'stop' || msg === 'start')
				await mqttClient.publishAsync(`sodapop/rx/${msg}`, msg);
		});

		connection.on('close', () => {
			fastify.log.info('Websocket client disconnected');

			// no need to listen if client is disconnected
			mqttClient.off('message', mqttMessageHandler);
			dataProcessor.off('error', errorHandler);
			dataProcessor.off('warning', warningHandler);
		});
	});

	fastify.get('/logs', async (_, reply) => {
		const logs = await db
			.select()
			.from(logsTable)
			.where(
				or(eq(logsTable.logType, 'error'), eq(logsTable.logType, 'warning'))
			)
			.orderBy(desc(logsTable.createdAt))
			.limit(25);

		reply.send(logs);
	});
});

/**
 * Listener
 */

fastify.listen({ port: 3000, host: '0.0.0.0' }, async (err, _) => {
	if (err) {
		fastify.log.error(`Error starting server: ${err}`);
		process.exit(1);
	}

	await mqttClient.subscribeAsync('sodapop/tx/#');
	await handleDataLogging(dataProcessor, mqttClient);
});
