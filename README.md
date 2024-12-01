# sodapop

`sodapop` is a system architecture meant to minmic the inner-workings of a bottling factory of any kind. It encompasses four fundamental components: the Human Machine Interface ("HMI"), the data processing utility, the MQTT broker, and, of course, the sensors.

## HMI

The HMI is a QML application that creates a WebSocket connection with the data processing utility ("DPU"). A WebSocket message will contain a payload that communicates errors, warnings, and data transmissions that are processed by the DPU. Once this message is received, the HMI will update its UI appropriately. The HMI contains a main view which showcases the flow of the production line along with key metrics, which is typical of a SCADA HMI. While the system does not presently support the acknowledgement of errors and warnings in the system as a normal SCADA system should, errors and warnings are presented to the operator using a notification card at the top right side of the screen. This notification is followed by a sound that continuously plays until the operator dismisses the error or warning. Errors and warnings are also logged in a separate page, presented in a tabular format.

## Data Processing Utility

The DPU is chiefly responsible for processing the data collected from the Remote Terminal Unit (RTU). This architecture was decided on as it felt unconventional to retain payloads sent to the MQTT broker through the HMI. While such a design is possible, it would decentralize the data collected and be cumbersome to do other analysis on the data, such as a Business Intelligence ("BI") report by way of tools such as Microsoft Power BI. This also abstracts the HMI entirely; in the event of a failure that destroys the HMI, the HMI can be restored on an entirely different device and retain the same data. While data losses are ultimately unavoidable due to a variety of external variables, it is in a SCADA Engineer's best interest to minimize the chance of this data loss, especially in environments that may require the metrics for billing customers (such as energy). 

Such a choice of centralizing the data collected also allows for common practices involving containerization to be employed, such as fault tolerance and scalability, through means such as Kubernetes, deployed on-premise or through any cloud provider supporting Kubernetes clusters, which most do. To facilitate a quick deployment of the DPU for the competition, we chose to employ a Node.JS backend that hosts an HTTP server and a WebSocket server. Node.JS allows us to use the Drizzle ORM coupled with TypeScript, simplifying the SQL queries made to the database and, further, leading to quick deployment. There are some performance drawbacks to this solution, described in a later section.

For the database that supports the DPU, we chose to use PostgreSQL and deploy the system with Kubernetes. While a serverless PostgreSQL instance such as NeonDB could also be used, it makes more sense to secure the database in the Kubernetes cluster, as that would be more typical of a SCADA system. The DPU's HTTP and WebSocket ports are the only components exposed for this project, though the PostgreSQL database could also be exposed if BI reports, or any external access to the database, is required.

The Kubernetes cluster also hosts the MQTT Broker, as discussed below. A Traefik reverse proxy is utilized as a load balancer that enforces TLS encryption through Let's Encrypt for all microservices in the system architecture.

## MQTT Broker

The MQTT Broker of choice is Eclipse Mosquitto, as recommended in the project specifications. The MQTT Broker is also deployed in the Kubernetes cluster, though Mosquitto has limitations on replica pods in a deployment due to its lack of state between multiple broker instances. For these reasons, perhaps EMQX would have been a better solution, though due to time constraints we did not explore EMQX very thoroughly and use only a single pod for the Broker. 

The MQTT Broker is configured to only accept TLS certificates, a de facto solution for authenticating securely with the Broker. The DPU subscribes to topics on the Broker while the RTU publishes to such topics. They share an identical payload that is specified in a later section.

## Remote Terminal Unit

In any SCADA system, at a fundamental level, there is a Programmable Logic Controller (PLC) and a Remote Terminal Unit (RTU). In our context, we chose a physical RTU to simulate sensor data being published to the MQTT Broker. The RTU is an ESP32 microprocessor (`ESP-WROOM-32 CP2012`) that connects to a WiFi network capable of accessing the Internet (as the MQTT Broker is hosted externally).

## Payload

The transmitted payload can be described best using a TypeScript interface, as that is how it originated.

```ts
interface BaseDevicePayload {
  device: {
    id: number;
    type: 'rising' | 'filling' | 'capping' | 'labeling' | 'packing';
  };
}

interface DeviceData {
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

interface WarningPayload<T extends DeviceWarningCode> extends BaseDevicePayload {
  type: 'warning';
  warningCode: T;
}

interface ErrorPayload<T extends DeviceErrorCode> extends BaseDevicePayload {
  type: 'error';
  errorCode: T;
}

interface DataPayload<T extends keyof DeviceData> extends BaseDevicePayload {
  type: 'data';
  device: {
    id: number;
    type: T;
  };
  metrics: DeviceData[T];
}

enum RisingMachineErrorCodes {
  TemperatureExceed = 1,
  TemperatureBelow = 2,
  PHValueFailThreshold = 3,
  FlowRateBelow = 4,
  PumpFailure = 5,
}

enum RisingMachineWarningCodes {
  TemperatureUpper = 1,
  TemperatureApproaching = 2,
  FlowRateAbove = 3,
  PHValueTrending = 4,
}

enum FillingMachineErrorCodes {
  TankLevelBelow = 1,
  PressureExceed = 2,
  PressureBelow = 3,
  FillRateBelow = 4,
  SystemMalfunction = 5,
}

enum FillingMachineWarningCodes {
  TankLevelBelow = 1,
  BottleWeightLess = 2,
}

enum CappingMachineErrorCodes {
  TorqueExceeds = 1,
  TorqueBelow = 2,
  CapSupplyEmpty = 3,
  TorqueFailure = 4,
}

enum CappingMachineWarningCodes {
  CapSupplyLow = 1,
  TorqueValuesHighVariance = 2,
}

enum LabelingMachineErrorCodes {
  LabelSupplyEmpty = 1,
  PositionOffsetExceeds = 2,
  VisionSystemLabelDefect = 3,
}

enum LabelingMachineWarningCodes {
  LabelSupplyLow = 1,
  PositionOffsetUpper = 2,
}

enum PackingMachineErrorCodes {
  BoxSupplyEmpty = 1,
  BoxWeightOutside = 2,
  BoxWeightFailures = 3,
}

enum PackingMachineWarningCodes {
  BoxSupplyLow = 1,
  BoxWeightUpper = 2,
}

type DeviceWarningCode = 
  | RisingMachineWarningCodes
  | FillingMachineWarningCodes
  | CappingMachineWarningCodes
  | LabelingMachineWarningCodes
  | PackingMachineWarningCodes;

type DeviceErrorCode =
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

type Payload =
  | RisingMachinePayload
  | FillingMachinePayload
  | CappingMachinePayload
  | LabelingMachinePayload
  | PackingMachinePayload;
```

## Limitations

The designed system, as remarked a few times throughout the document, does have some limitations that are worth discussing. These limitations involve the choice of language for the DPU, the choice of Mosquitto as the MQTT Broker, the choice of utilizing a custom specification for the data payload, and the choice of microprocessor.

### Choice of DPU Language

To begin, the choice of TypeScript for the DPU, while beneficial to facilitate a quicker deployment, has performance drawbacks in times of heavy demand for data processing. TypeScript is transpiled into JavaScript, which is interpreted using NodeJS. This already has an overhead at the cost of abstraction on top of the overhead C++, or any compiled language for that matter, has when being compiled into raw assembly; however, the fact that JavaScript code is interpreted at runtime also introduces a latency in data processing, which could be catastrophic to a high-demand SCADA system that relys on nearly real-time data. 

Should this be an issue in an implementation, the Kubernetes cluster could be utilized to orchestrate multiple replicas of the DPU, also deploying a message queue that load balances between each replica. This approach introduces more complexity in the system and requires more system resources. Thus, it could be advantageous to explore lower-level languages such as C++, Rust, or Go for the implementation of the DPU and seeing if the performance time of these compiled languages would sufficiently solve latency.

### Choice of Mosquitto

Mosquitto being the MQTT Broker in this instance could introduce potential bottlenecks as the system scales; Mosquitto is **not** stateful out of the box. Further, it is difficult to take advantage of the Kubernetes architecture. One MQTT Broker that supports such a stateful system is the EMQX Broker, which can easily be set up with Kubernetes as it comes with a Helm chart. 

This consideration is overkill for the scope of this project, despite the choice of Kubernetes also being overkill. Mosquitto can comfortably run hundreds, if not thousands, of data influxes on a single instance without having to rely on load balancing replicas. Hence, to save time here, we do not consider another MQTT Broker, but it could be useful for enterprise systems that could benefit from such load balancing.

### Choice of Custom Specification

The choice of a custom specification is sufficient for the system architecture implemented here; however, it requires that the firmware, or process executed on the microprocessor, know how to package the payload properly and interpret payloads. Since the specification was purpose-built for the theoretical SCADA factory, future expansion of this specification could be limiting, as updating it requires updating the firmware and pushing the firmware update to all on-field devices. If Over-the-Air (OTA) firmware updates are not supported on a particular field device, a technician needs to be sent on site to update the firmware, which could prove a waste of company resources. It is for this reason that open-source specifications, such as MQTT Sparkplug B, exist and are already baked into the firmware.

Open-source specifications take time to learn due to their maturity and inclusivity to support an abstract solution, applicable to most IIoT applications (spoiler alert: there's a lot of them). Despite this, it is advantageous to implement open-source specifications over proprietary when possible due to their adaptation in existing firmwares and their relatively small size.

### Choice of Microprocessor

The selected microprocessor, while cheap to order, does not support cellular and only communicates with the Mosquitto Broker via WiFi (and an external communication at that). This could be an issue in a SCADA system that either does not have WiFi on-premise or does not allow, or limits, Wide Area Network (WAN) connections. A cellular device could be used to remedy these issues and even employ Extended Discontinuous Reception (eDRX) to lessen power consumption in communicating sensor data to the Broker. 

In cases where there is limited availability of WiFi at a factory or a SCADA implementation, an implementation using a radio could be explored to mesh RTUs that do not have WiFi and ones that do to reliably send all sensor data to the MQTT Broker.