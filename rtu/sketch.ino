#include <WiFiClientSecure.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <certs.h>

const char* ssid = "";
const char* password = "";

const char* mqttServer = "mqtt.colin.gg";
const int mqttPort = 8883;
const char* mqttUsername = "test";
const char* mqttClientId = "ESP32Client";

bool isActive = true;

WiFiClientSecure espClient;
PubSubClient client(espClient);

const char* deviceTypes[] = {
  "rising",
  "filling",
  "capping",
  "labeling",
  "packing"
};

const char* logTypes[] = {
  "error",
  "warning",
  "data"
};

class DeviceMetric {
  char* name;
  float start;
  float end;
  bool isWholeNumber;
  bool isCountdown;
  mutable float currentCount;
  float resetValue;

  public:
  bool isBoolean;

  DeviceMetric(char* name, float start, float end, bool isWholeNumber = false, bool isBoolean = false, bool isCountdown = false, float resetValue = 0) {
    this->name = name;
    this->start = start;
    this->end = end;
    this->isWholeNumber = isWholeNumber;
    this->isBoolean = isBoolean;
    this->isCountdown = isCountdown;
    this->resetValue = resetValue;
    this->currentCount = resetValue > 0 ? resetValue : 0;
  }

  float generateRandomValue() const {
    if (isCountdown) {
      if (currentCount <= 0) {
        currentCount = resetValue;
      } else {
        currentCount--;
      }
      return currentCount;
    }
    
    if (isWholeNumber) {
      return (float)((int)random(start, end + 1));
    } else {
      return random(start, end + 1) + random(0, 10000) / 10000.0;
    }  
  }

  char* getName() const {
    return this->name;
  }
};

const DeviceMetric risingDeviceMetrics[] = {
  DeviceMetric("temperature", 50, 90),
  DeviceMetric("flow", 80, 220),
  DeviceMetric("PH", 11, 13)
};

const DeviceMetric fillingDeviceMetrics[] = {
  DeviceMetric("level", 0, 100),
  DeviceMetric("flow", 10, 50),
  DeviceMetric("pressure", 1, 5),
  DeviceMetric("weight", 340, 410)
};

const DeviceMetric cappingDeviceMetrics[] = {
  DeviceMetric("torque", 0.5, 3.0),
  DeviceMetric("count", 0, 10000, true, false, true, 10000)
};

const DeviceMetric labelingDeviceMetrics[] = {
  DeviceMetric("vision", 0, 1, true, true),
  DeviceMetric("count", 0, 10000, true, false, true, 10000),
  DeviceMetric("position", -3, 3)
};

const DeviceMetric packingMachineMetrics[] = {
  DeviceMetric("count", 0, 10000, true, false, true, 10000),
  DeviceMetric("weight", 3, 6)
};

struct MetricsArray {
  const DeviceMetric* metrics;
  size_t size;
};

MetricsArray getDeviceMetrics(const char* deviceType) {
  MetricsArray result;

  if (deviceType == "rising") {
    result.metrics = risingDeviceMetrics;
    result.size = 3;
  } else if (deviceType == "filling") {
    result.metrics = fillingDeviceMetrics;
    result.size = 4;
  } else if (deviceType == "capping") {
    result.metrics = cappingDeviceMetrics;
    result.size = 2;
  } else if (deviceType == "labeling") {
    result.metrics = labelingDeviceMetrics;
    result.size = 3;
  } else if (deviceType == "packing") {
    result.metrics = packingMachineMetrics;
    result.size = 2;
  }

  return result;
}

void callback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (int i = 0; i < length; i++) {
    message += (char) payload[i];
  }

  if (message == "start") {
    isActive = isActive ? !isActive : isActive;
  } else if (message == "stop") {
    isActive = !isActive ? isActive : !isActive;
  }
}

void setup() {
  randomSeed(analogRead(0));

  Serial.begin(115200);

  WiFi.begin(ssid, password);

  espClient.setCACert(root_ca);
  espClient.setCertificate(client_cert);
  espClient.setPrivateKey(client_key);

  client.setServer(mqttServer, mqttPort);
  client.setCallback(callback);
} 

void reconnect() {
  Serial.println("Attempting to connect to MQTT");
  if (client.connect(mqttClientId, mqttUsername, "")) {
    Serial.println("Connected to MQTT");
    client.subscribe("sodapop/rx/#");
  } else {
    Serial.print("Failed, rc=");
    Serial.print(client.state());
    Serial.println(" Retrying in 5 seconds");
    delay(5000);
  }
}

void sendRandomizedData() {
  int i = 1;
  for (auto deviceType : deviceTypes) {
    StaticJsonDocument<400> payload;

    payload["type"] = "data";
    
    JsonObject device = payload.createNestedObject("device");
    device["id"] = i;
    device["type"] = deviceType;

    MetricsArray deviceMetrics = getDeviceMetrics(deviceType);

    JsonObject metrics = payload.createNestedObject("metrics");

    for (size_t i = 0; i < deviceMetrics.size; i++) {
      const DeviceMetric& deviceMetric = deviceMetrics.metrics[i];

      float value = deviceMetric.generateRandomValue();
      metrics[deviceMetric.getName()] = deviceMetric.isBoolean ? ((bool) value) : value;
    }

    String jsonString;
    serializeJson(payload, jsonString);
    client.publish(("sodapop/tx/" + String(deviceType)).c_str(), jsonString.c_str());
  }
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  if (isActive) {
    sendRandomizedData();

    delay(5000); // every 5 seconds, send new data
  }
}
