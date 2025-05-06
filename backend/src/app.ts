import "dotenv/config";
import Fastify from "fastify";
import websocketPlugin from "@fastify/websocket";
import mqtt from "mqtt";
import { handleDataLogging } from "./lib/mqtt";
import { db } from "./lib/db";
import { logsTable } from "./schema";
import { desc, eq, or } from "drizzle-orm";
import type {
  DeviceErrorCode,
  DeviceWarningCode,
  ErrorPayload,
  WarningPayload,
} from "./interfaces";
import { DataProcessor } from "./lib/dataProcessor";
import { handleIssueLogging } from "./lib/issue";

// Add unhandled rejection handler
process.on("unhandledRejection", (reason, promise) => {
  console.error("Unhandled Rejection at:", promise, "reason:", reason);
});

/**
 * Fastify initializations
 */
const fastify = Fastify({
  logger: {
    level: "debug", // Increase log level for more detail
    transport: {
      target: "pino-pretty",
    },
  },
});

fastify.register(websocketPlugin);

// Rudimentary authorization (only HMI will connect anyway)
fastify.addHook("onRequest", async (request, reply) => {
  if (request.headers.authorization !== process.env.SECRET_KEY) {
    reply.code(401).send({ error: "Unauthorized" });
  }
});

/**
 * MQTT initializations
 */
const username = process.env.MQTT_USERNAME;
const password = process.env.MQTT_PASSWORD;
const mqttUrl = process.env.MQTT_URL;

if (!mqttUrl) {
  fastify.log.error("MQTT_URL not defined in environment");
  process.exit(1);
}

// Track MQTT connection state
let mqttConnected = false;

// Create client with explicit options and type assertions for QoS
const mqttClient = mqtt.connect(mqttUrl, {
  clientId: `backend-${Math.random().toString(16).slice(2, 8)}`,
  clean: true,
  connectTimeout: 4000,
  reconnectPeriod: 1000,
  username,
  password,
  rejectUnauthorized: false,
  will: {
    topic: "sodapop/status",
    payload: JSON.stringify({ status: "backend-offline" }),
    qos: 0 as 0,
    retain: false,
  },
});

// Enhanced MQTT event handlers
mqttClient.on("connect", () => {
  mqttConnected = true;
  fastify.log.info("MQTT connected");

  // Subscribe to topics on connect/reconnect
  mqttClient.subscribe("sodapop/tx/#", (err) => {
    if (err) {
      fastify.log.error(`Failed to subscribe to MQTT topics: ${err.message}`);
    } else {
      fastify.log.info("Subscribed to sodapop/tx/# topics");
    }
  });
});

mqttClient.on("error", (error) => {
  fastify.log.error(`MQTT error: ${error.message}`);
});

mqttClient.on("offline", () => {
  mqttConnected = false;
  fastify.log.warn("MQTT client is offline");
});

mqttClient.on("reconnect", () => {
  fastify.log.info("MQTT reconnecting...");
});

mqttClient.on("message", (topic, message) => {
  fastify.log.debug(
    { topic, message: message.toString() },
    "MQTT message received"
  );
});

/**
 * Data Processing
 */
const dataProcessor = new DataProcessor();

// Add debug logging to data processor events
dataProcessor.on("error", async (payload) => {
  fastify.log.info({ payload }, "Error event from data processor");
  try {
    await handleIssueLogging(payload);
  } catch (error) {
    fastify.log.error(
      { error, payload },
      "Failed to handle error issue logging"
    );
  }
});

dataProcessor.on("warning", async (payload) => {
  fastify.log.info({ payload }, "Warning event from data processor");
  try {
    await handleIssueLogging(payload);
  } catch (error) {
    fastify.log.error(
      { error, payload },
      "Failed to handle warning issue logging"
    );
  }
});

// Add debug to see what data is being processed
// Only add this if DataProcessor has a 'data' event in its type definition
// dataProcessor.on('data', (payload) => {
//   fastify.log.debug({ payload }, 'Data event from data processor');
// });

/**
 * Fastify routes
 */
fastify.register(async (fastify) => {
  // Track active WebSocket connections
  const activeConnections = new Set();

  fastify.get("/ws", { websocket: true }, (connection, req) => {
    fastify.log.info("WebSocket client connected");
    activeConnections.add(connection);

    let messageCount = 0;

    // Send initial connection status
    connection.send(
      JSON.stringify({
        type: "connection",
        status: "connected",
        mqttConnected,
      })
    );

    const mqttMessageHandler = (topic: string, message: Buffer) => {
      try {
        // Debug logging
        messageCount++;
        if (messageCount % 10 === 0) {
          fastify.log.debug(
            `Sent ${messageCount} messages to WebSocket client`
          );
        }

        connection.send(message.toString());
      } catch (error) {
        fastify.log.error({ error }, "Error sending message to WebSocket");
      }
    };

    const errorHandler = (payload: ErrorPayload<DeviceErrorCode>) => {
      try {
        connection.send(JSON.stringify(payload));
      } catch (error) {
        fastify.log.error({ error }, "Error sending error to WebSocket");
      }
    };

    const warningHandler = (payload: WarningPayload<DeviceWarningCode>) => {
      try {
        connection.send(JSON.stringify(payload));
      } catch (error) {
        fastify.log.error({ error }, "Error sending warning to WebSocket");
      }
    };

    // Ping client every 30 seconds to keep connection alive
    const pingInterval = setInterval(() => {
      try {
        // Send a ping message instead of using socket.ping
        connection.send(
          JSON.stringify({ type: "ping", timestamp: Date.now() })
        );
        fastify.log.debug("Sent ping to WebSocket client");
      } catch (error) {
        fastify.log.error({ error }, "Failed to ping WebSocket client");
        clearInterval(pingInterval);
      }
    }, 30000);

    mqttClient.on("message", mqttMessageHandler);
    dataProcessor.on("error", errorHandler);
    dataProcessor.on("warning", warningHandler);

    connection.on("message", async (message) => {
      const msg = message.toString();
      fastify.log.info(`Received WebSocket message: ${msg}`);

      if (msg === "stop" || msg === "start") {
        try {
          if (mqttConnected) {
            await new Promise<void>((resolve, reject) => {
              mqttClient.publish(`sodapop/rx/${msg}`, msg, (err) => {
                if (err) reject(err);
                else resolve();
              });
            });
            fastify.log.info(`Published ${msg} command to MQTT`);
          } else {
            fastify.log.warn("Cannot publish command - MQTT not connected");
            connection.send(
              JSON.stringify({
                type: "error",
                message: "MQTT broker not connected",
              })
            );
          }
        } catch (error: unknown) {
          fastify.log.error({ error }, "Error publishing to MQTT");
          connection.send(
            JSON.stringify({
              type: "error",
              message: `Failed to publish command: ${
                error instanceof Error ? error.message : "Unknown error"
              }`,
            })
          );
        }
      }
    });

    connection.on("close", () => {
      fastify.log.info("WebSocket client disconnected");
      activeConnections.delete(connection);
      clearInterval(pingInterval);

      // Remove all event listeners
      mqttClient.off("message", mqttMessageHandler);
      dataProcessor.off("error", errorHandler);
      dataProcessor.off("warning", warningHandler);
    });

    connection.on("error", (error) => {
      fastify.log.error({ error }, "WebSocket connection error");
    });
  });

  fastify.get("/logs", async (request, reply) => {
    try {
      const logs = await db
        .select()
        .from(logsTable)
        .where(
          or(eq(logsTable.logType, "error"), eq(logsTable.logType, "warning"))
        )
        .orderBy(desc(logsTable.createdAt))
        .limit(25);

      reply.send(logs);
    } catch (error) {
      fastify.log.error({ error }, "Error fetching logs");
      reply.status(500).send({ error: "Failed to fetch logs" });
    }
  });

  // Health check endpoint
  fastify.get("/health", async (request, reply) => {
    return {
      status: "ok",
      time: new Date().toISOString(),
      mqttConnected,
      websocketClients: activeConnections.size,
    };
  });
});

/**
 * Start server and initialize listeners
 */
const start = async () => {
  try {
    // Start the HTTP server
    const address = await fastify.listen({ port: 3000, host: "0.0.0.0" });
    fastify.log.info(`Server listening at ${address}`);

    // Initialize data logging with proper error handling
    try {
      fastify.log.info("Starting data logging handler");
      await handleDataLogging(dataProcessor, mqttClient);
      fastify.log.info("Data logging handler started successfully");
    } catch (error) {
      fastify.log.error({ error }, "Failed to initialize data logging");
      // Don't exit - the server should still run even if data logging fails
    }
  } catch (err) {
    fastify.log.error(`Error starting server: ${err}`);
    process.exit(1);
  }
};

// Start the server
start();
