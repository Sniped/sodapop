// datamanager.cpp
#include "datamanager.h"
#include <QDebug>

DataManager::DataManager(QObject *parent)
    : QObject(parent)
{
    connect(&m_webSocket, &QWebSocket::connected, this, &DataManager::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &DataManager::onDisconnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &DataManager::onTextMessageReceived);

    qDebug() << "asdasdasdasdasdasd";

    QNetworkRequest request(QUrl("wss://sodapop.colin.gg/ws"));
    request.setRawHeader("Authorization", "e48y5QfmnJSCae5gMJsd");

    qDebug() << "Connecting to WebSocket server...";
    m_webSocket.open(request);
}

void DataManager::connectToServer()
{
    QNetworkRequest request(QUrl("wss://sodapop.colin.gg/ws"));
    request.setRawHeader("Authorization", "e48y5QfmnJSCae5gMJsd");

    qDebug() << "Connecting to WebSocket server...";
    m_webSocket.open(request);
}

void DataManager::onConnected()
{
    qDebug() << "WebSocket connected";
}

void DataManager::onDisconnected()
{
    qDebug() << "WebSocket disconnected";
}

void DataManager::onTextMessageReceived(const QString &message)
{
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8());
    if (doc.isObject()) {
        parseDeviceData(doc.object());
    }
}

void DataManager::parseDeviceData(const QJsonObject &data)
{
    // Rising section
    if (data.contains("rising")) {
        QJsonObject rising = data["rising"].toObject();
        qDebug() << "Rising:";
        qDebug() << "  Temperature:" << rising["temperature"].toDouble();
        qDebug() << "  Flow:" << rising["flow"].toDouble();
        qDebug() << "  PH:" << rising["PH"].toDouble();
    }

    // Filling section
    if (data.contains("filling")) {
        QJsonObject filling = data["filling"].toObject();
        qDebug() << "Filling:";
        qDebug() << "  Level:" << filling["level"].toDouble();
        qDebug() << "  Flow:" << filling["flow"].toDouble();
        qDebug() << "  Pressure:" << filling["pressure"].toDouble();
        qDebug() << "  Weight:" << filling["weight"].toDouble();
    }

    // Capping section
    if (data.contains("capping")) {
        QJsonObject capping = data["capping"].toObject();
        qDebug() << "Capping:";
        qDebug() << "  Torque:" << capping["torque"].toDouble();
        qDebug() << "  Count:" << capping["count"].toInt();
    }

    // Labeling section
    if (data.contains("labeling")) {
        QJsonObject labeling = data["labeling"].toObject();
        qDebug() << "Labeling:";
        qDebug() << "  Vision:" << labeling["vision"].toBool();
        qDebug() << "  Count:" << labeling["count"].toInt();
        qDebug() << "  Position:" << labeling["position"].toDouble();
    }

    // Packing section
    if (data.contains("packing")) {
        QJsonObject packing = data["packing"].toObject();
        qDebug() << "Packing:";
        qDebug() << "  Count:" << packing["count"].toInt();
        qDebug() << "  Weight:" << packing["weight"].toDouble();
    }
}
