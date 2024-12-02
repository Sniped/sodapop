import {
	CappingMachineErrorCodes,
	CappingMachineWarningCodes,
	FillingMachineErrorCodes,
	FillingMachineWarningCodes,
	LabelingMachineErrorCodes,
	LabelingMachineWarningCodes,
	PackingMachineErrorCodes,
	PackingMachineWarningCodes,
	RisingMachineErrorCodes,
	RisingMachineWarningCodes,
	type DeviceRules,
} from '../interfaces';

export const deviceRules: DeviceRules = {
	rising: {
		temperature: {
			errors: [
				{
					check: temp => temp > 80,
					code: RisingMachineErrorCodes.TemperatureExceed,
				},
				{
					check: temp => temp < 60,
					code: RisingMachineErrorCodes.TemperatureBelow,
				},
			],
			warnings: [
				{
					check: temp => temp > 75,
					code: RisingMachineWarningCodes.TemperatureUpper,
				},
				{
					check: temp => temp < 65,
					code: RisingMachineWarningCodes.TemperatureApproaching,
				},
			],
		},
		flow: {
			errors: [
				{
					check: flow => flow < 100,
					code: RisingMachineErrorCodes.FlowRateBelow,
				},
				{
					check: flow => flow === 0,
					code: RisingMachineErrorCodes.PumpFailure,
				},
			],
			warnings: [
				{
					check: flow => flow > 180,
					code: RisingMachineWarningCodes.FlowRateAbove,
				},
			],
		},
		PH: {
			errors: [
				{
					check: ph => ph < 11 || ph > 13,
					code: RisingMachineErrorCodes.PHValueFailThreshold,
				},
			],
			warnings: [
				{
					check: ph => ph <= 11.2 || ph >= 12.8,
					code: RisingMachineWarningCodes.PHValueTrending,
				},
			],
		},
	},
	filling: {
		level: {
			errors: [
				{
					check: level => level <= 10,
					code: FillingMachineErrorCodes.TankLevelBelow,
				},
			],
			warnings: [
				{
					check: level => level <= 25,
					code: FillingMachineWarningCodes.TankLevelBelow,
				},
			],
		},
		pressure: {
			errors: [
				{
					check: pressure => pressure > 4,
					code: FillingMachineErrorCodes.PressureExceed,
				},
				{
					check: pressure => pressure < 2,
					code: FillingMachineErrorCodes.PressureBelow,
				},
			],
			warnings: [],
		},
		flow: {
			errors: [
				{
					check: flow => flow < 20,
					code: FillingMachineErrorCodes.FillRateBelow,
				},
			],
			warnings: [],
		},
		weight: {
			errors: [],
			warnings: [
				{
					check: weight => weight < 350,
					code: FillingMachineWarningCodes.BottleWeightLess,
				},
			],
		},
	},
	capping: {
		torque: {
			errors: [
				{
					check: torque => torque > 3.0,
					code: CappingMachineErrorCodes.TorqueExceeds,
				},
				{
					check: torque => torque < 0.5,
					code: CappingMachineErrorCodes.TorqueBelow,
				},
			],
			warnings: [],
		},
		count: {
			errors: [
				{
					check: count => count === 0,
					code: CappingMachineErrorCodes.CapSupplyEmpty,
				},
			],
			warnings: [
				{
					check: count => count < 1000,
					code: CappingMachineWarningCodes.CapSupplyLow,
				},
			],
		},
	},
	labeling: {
		vision: {
			errors: [],
			warnings: [],
		},
		count: {
			errors: [
				{
					check: count => count === 0,
					code: LabelingMachineErrorCodes.LabelSupplyEmpty,
				},
			],
			warnings: [
				{
					check: count => count < 1000,
					code: LabelingMachineWarningCodes.LabelSupplyLow,
				},
			],
		},
		position: {
			errors: [
				{
					check: pos => Math.abs(pos) > 2,
					code: LabelingMachineErrorCodes.PositionOffsetExceeds,
				},
			],
			warnings: [
				{
					check: pos => Math.abs(pos) > 1.5,
					code: LabelingMachineWarningCodes.PositionOffsetUpper,
				},
			],
		},
	},
	packing: {
		count: {
			errors: [
				{
					check: count => count === 0,
					code: PackingMachineErrorCodes.BoxSupplyEmpty,
				},
			],
			warnings: [
				{
					check: count => count < 1000,
					code: PackingMachineWarningCodes.BoxSupplyLow,
				},
			],
		},
		weight: {
			errors: [
				{
					check: weight => weight < 4 || weight > 5,
					code: PackingMachineErrorCodes.BoxWeightOutside,
				},
			],
			warnings: [
				{
					check: weight =>
						(weight >= 4.8 && weight <= 5) || (weight >= 4 && weight <= 4.2),
					code: PackingMachineWarningCodes.BoxWeightUpper,
				},
			],
		},
	},
};
