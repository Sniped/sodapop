import 'dotenv/config';
import Fastify from 'fastify';
import websocketPlugin from '@fastify/websocket';
import mqtt from 'mqtt';
import { handleDataLogging } from './lib/mqtt';
import { db } from './lib/db';
import { logsTable } from './schema';
import { desc } from 'drizzle-orm';

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

// Raw paths (to be read)
const mqttCaCertPath = process.env.MQTT_CA_CERT || 'certs/ca.crt';
const mqttClientCertPath = process.env.MQTT_CLIENT_CERT || 'certs/client.crt';
const mqttClientKeyPath = process.env.MQTT_CLIENT_KEY || 'certs/client.key';

// Read the files as text
const mqttCaCert = await Bun.file(mqttCaCertPath).text();
const mqttClientCert = await Bun.file(mqttClientCertPath).text();
const mqttClientKey = await Bun.file(mqttClientKeyPath).text();

const mqttClient = await mqtt.connectAsync(process.env.MQTT_URL!, {
	clientId: `backend-${Math.random().toString(16).slice(2, 8)}`,
	clean: true,
	connectTimeout: 4000, // 4 seconds
	reconnectPeriod: 1000, // 1 second
	ca: mqttCaCert,
	cert: mqttClientCert,
	key: mqttClientKey,
});

mqttClient.on('connect', async () => {
	fastify.log.info('MQTT connected');

	await mqttClient.subscribeAsync('sodapop/tx/#');

	await handleDataLogging(mqttClient);
});

mqttClient.on('error', error => {
	fastify.log.error(`Error connecting to MQTT: ${error}`);
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

		mqttClient.on('message', mqttMessageHandler);

		connection.on('close', () => {
			fastify.log.info('Websocket client disconnected');

			// no need to listen if client is disconnected
			mqttClient.off('message', mqttMessageHandler);
		});
	});

	fastify.get('/logs', async (_, reply) => {
		const logs = await db
			.select()
			.from(logsTable)
			.orderBy(desc(logsTable.createdAt))
			.limit(25);

		reply.send(logs);
	});
});

/**
 * Listener
 */

fastify.listen({ port: 3000 }, (err, _) => {
	if (err) {
		fastify.log.error(`Error starting server: ${err}`);
		process.exit(1);
	}
});
