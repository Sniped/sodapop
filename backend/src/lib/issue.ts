import type {
	DeviceErrorCode,
	DeviceWarningCode,
	ErrorPayload,
	WarningPayload,
} from '../interfaces';
import { logsTable } from '../schema';
import { db } from './db';

export async function handleIssueLogging(
	payload: ErrorPayload<DeviceErrorCode> | WarningPayload<DeviceWarningCode>
) {
	await db.insert(logsTable).values({
		deviceType: payload.device.type,
		logType: payload.type,
		code: payload.type === 'error' ? payload.errorCode : payload.warningCode,
	});
}
