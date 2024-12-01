import type mqtt from 'mqtt';
import type { Payload } from '../interfaces';
import { db } from './db';
import { logsTable } from '../schema';

export async function handleDataLogging(mqttClient: mqtt.MqttClient) {
	mqttClient.on('message', async (_, message) => {
		const payload: Payload = JSON.parse(message.toString());

		let code: number | undefined;
		let data: object | undefined;

		if (payload.type == 'error') code = payload.errorCode;
		else if (payload.type == 'warning') code = payload.warningCode;
		else if (payload.type == 'data') data = payload.metrics;

		await db.insert(logsTable).values({
			deviceType: payload.device.type,
			logType: payload.type,
			code,
			data,
		});
	});
}
