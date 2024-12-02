import type mqtt from 'mqtt';
import type { Payload } from '../interfaces';
import { db } from './db';
import { logsTable } from '../schema';
import { DataProcessor } from './dataProcessor';

export async function handleDataLogging(
	dataProcessor: DataProcessor,
	mqttClient: mqtt.MqttClient
) {
	mqttClient.on('message', async (_, message) => {
		const payload: Payload = JSON.parse(message.toString());

		let code: number | undefined;
		let data: object | undefined;

		if (payload.type == 'data') {
			data = payload.metrics;
			dataProcessor.processDataPayload(payload);
		}

		await db.insert(logsTable).values({
			deviceType: payload.device.type,
			logType: payload.type,
			code,
			data,
		});
	});
}
