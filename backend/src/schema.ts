import { integer, json, pgEnum, pgTable, timestamp } from 'drizzle-orm/pg-core';

export const deviceTypeEnum = pgEnum('device_type', [
	'rising',
	'filling',
	'capping',
	'labeling',
	'packing',
]);

export const logTypeEnum = pgEnum('log_type', ['error', 'warning', 'data']);

export const logsTable = pgTable('logs', {
	id: integer().primaryKey().generatedAlwaysAsIdentity(),
	deviceType: deviceTypeEnum('device_type').notNull(),
	logType: logTypeEnum('log_type').notNull(),
	code: integer(),
	data: json().$type<object>(),
	createdAt: timestamp('created_at').defaultNow().notNull(),
});
