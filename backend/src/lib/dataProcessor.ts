import { EventEmitter } from 'events';
import type {
	DataPayload,
	DeviceData,
	DeviceErrorCode,
	DeviceType,
	DeviceWarningCode,
	ErrorPayload,
	WarningPayload,
} from '../interfaces';
import { deviceRules } from '../utils/constants';

interface Events {
	error: (payload: ErrorPayload<DeviceErrorCode>) => void;
	warning: (payload: WarningPayload<DeviceWarningCode>) => void;
}

export class DataProcessor extends EventEmitter {
	constructor() {
		super();
	}

	on<K extends keyof Events>(event: K, listener: Events[K]): this {
		return super.on(event, listener);
	}

	off<K extends keyof Events>(eventName: K, listener: Events[K]): this {
		return super.off(eventName, listener);
	}

	emit<K extends keyof Events>(
		event: K,
		...args: Parameters<Events[K]>
	): boolean {
		return super.emit(event, ...args);
	}

	processDataPayload(payload: DataPayload<keyof DeviceData>) {
		const issues = DataProcessor.validateDataPayload(
			payload.device.type,
			payload.metrics
		);

		issues.forEach(issue => {
			if (issue.type === 'error') {
				this.emit('error', issue);
			} else {
				this.emit('warning', issue);
			}
		});
	}

	static validateDataPayload<T extends DeviceType>(
		deviceType: T,
		metrics: DeviceData[T]
	): Array<WarningPayload<DeviceWarningCode> | ErrorPayload<DeviceErrorCode>> {
		const rules = deviceRules[deviceType];
		const issues: Array<
			WarningPayload<DeviceWarningCode> | ErrorPayload<DeviceErrorCode>
		> = [];

		Object.entries(metrics).forEach(([metricKey, value]) => {
			const metric = metricKey as keyof DeviceData[T];
			const metricRules = rules[metric];
			const typedValue = value as DeviceData[T][typeof metric];

			metricRules.errors.forEach(rule => {
				if ((rule.check as (value: typeof typedValue) => boolean)(typedValue)) {
					issues.push({
						type: 'error',
						device: { id: 1, type: deviceType },
						errorCode: rule.code as DeviceErrorCode,
					});
				}
			});

			metricRules.warnings.forEach(rule => {
				if ((rule.check as (value: typeof typedValue) => boolean)(typedValue)) {
					issues.push({
						type: 'warning',
						device: { id: 1, type: deviceType },
						warningCode: rule.code as DeviceWarningCode,
					});
				}
			});
		});

		return issues;
	}
}
