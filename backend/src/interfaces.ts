export type DeviceType =
	| 'rising'
	| 'filling'
	| 'capping'
	| 'labeling'
	| 'packing';

export type LogType = 'error' | 'warning' | 'data';

interface ThresholdRule<T> {
	check: (value: T, context?: any) => boolean;
	code: number;
}

interface MetricRules<T> {
	errors: ThresholdRule<T>[];
	warnings: ThresholdRule<T>[];
}

export type DeviceRules = {
	[K in keyof DeviceData]: {
		[P in keyof DeviceData[K]]: MetricRules<DeviceData[K][P]>;
	};
};

interface BaseDevicePayload {
	device: {
		id: number;
		type: DeviceType;
	};
}

export interface DeviceData {
	rising: {
		temperature: number;
		flow: number;
		PH: number;
	};
	filling: {
		level: number;
		flow: number;
		pressure: number;
		weight: number;
	};
	capping: {
		torque: number;
		count: number;
	};
	labeling: {
		vision: boolean;
		count: number;
		position: number;
	};
	packing: {
		count: number;
		weight: number;
	};
}

export interface WarningPayload<T extends DeviceWarningCode>
	extends BaseDevicePayload {
	type: 'warning';
	warningCode: T;
}

export interface ErrorPayload<T extends DeviceErrorCode>
	extends BaseDevicePayload {
	type: 'error';
	errorCode: T;
}

export interface DataPayload<T extends keyof DeviceData>
	extends BaseDevicePayload {
	type: 'data';
	device: {
		id: number;
		type: T;
	};
	metrics: DeviceData[T];
}

export enum RisingMachineErrorCodes {
	TemperatureExceed = 1,
	TemperatureBelow = 2,
	PHValueFailThreshold = 3,
	FlowRateBelow = 4,
	PumpFailure = 5,
}

export enum RisingMachineWarningCodes {
	TemperatureUpper = 1,
	TemperatureApproaching = 2,
	FlowRateAbove = 3,
	PHValueTrending = 4,
}

export enum FillingMachineErrorCodes {
	TankLevelBelow = 1,
	PressureExceed = 2,
	PressureBelow = 3,
	FillRateBelow = 4,
	SystemMalfunction = 5,
}

export enum FillingMachineWarningCodes {
	TankLevelBelow = 1,
	BottleWeightLess = 2,
}

export enum CappingMachineErrorCodes {
	TorqueExceeds = 1,
	TorqueBelow = 2,
	CapSupplyEmpty = 3,
	TorqueFailure = 4,
}

export enum CappingMachineWarningCodes {
	CapSupplyLow = 1,
	TorqueValuesHighVariance = 2,
}

export enum LabelingMachineErrorCodes {
	LabelSupplyEmpty = 1,
	PositionOffsetExceeds = 2,
	VisionSystemLabelDefect = 3,
}

export enum LabelingMachineWarningCodes {
	LabelSupplyLow = 1,
	PositionOffsetUpper = 2,
}

export enum PackingMachineErrorCodes {
	BoxSupplyEmpty = 1,
	BoxWeightOutside = 2,
	BoxWeightFailures = 3,
}

export enum PackingMachineWarningCodes {
	BoxSupplyLow = 1,
	BoxWeightUpper = 2,
}

export type DeviceWarningCode =
	| RisingMachineWarningCodes
	| FillingMachineWarningCodes
	| CappingMachineWarningCodes
	| LabelingMachineWarningCodes
	| PackingMachineWarningCodes;

export type DeviceErrorCode =
	| RisingMachineErrorCodes
	| FillingMachineErrorCodes
	| CappingMachineErrorCodes
	| LabelingMachineErrorCodes
	| PackingMachineErrorCodes;

type RisingMachinePayload =
	| WarningPayload<RisingMachineWarningCodes>
	| ErrorPayload<RisingMachineErrorCodes>
	| DataPayload<'rising'>;

type FillingMachinePayload =
	| WarningPayload<FillingMachineWarningCodes>
	| ErrorPayload<FillingMachineErrorCodes>
	| DataPayload<'filling'>;

type CappingMachinePayload =
	| WarningPayload<CappingMachineWarningCodes>
	| ErrorPayload<CappingMachineErrorCodes>
	| DataPayload<'capping'>;

type LabelingMachinePayload =
	| WarningPayload<LabelingMachineWarningCodes>
	| ErrorPayload<LabelingMachineErrorCodes>
	| DataPayload<'labeling'>;

type PackingMachinePayload =
	| WarningPayload<PackingMachineWarningCodes>
	| ErrorPayload<PackingMachineErrorCodes>
	| DataPayload<'packing'>;

export type Payload =
	| RisingMachinePayload
	| FillingMachinePayload
	| CappingMachinePayload
	| LabelingMachinePayload
	| PackingMachinePayload;
