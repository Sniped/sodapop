// DataManager.cpp
#include "DataManager.h"

DataManager::DataManager(QObject *parent)
    : QObject(parent)
{
    connect(&m_webSocket, &QWebSocket::connected, this, &DataManager::onConnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &DataManager::onTextMessageReceived);
}

void DataManager::start()
{
    QNetworkRequest request(QUrl("wss://sodapop.colin.gg/ws"));
    request.setRawHeader("Authorization", "e48y5QfmnJSCae5gMJsd");
    m_webSocket.open(request);
}

void DataManager::onConnected()
{
    qDebug() << "WebSocket connected!";
}

void DataManager::onTextMessageReceived(const QString &message)
{
    QJsonDocument jsonDoc = QJsonDocument::fromJson(message.toUtf8());
    if (!jsonDoc.isObject()) return;

    QJsonObject jsonObject = jsonDoc.object();
    if (!jsonObject.contains("type")) return;

    QString messageType = jsonObject["type"].toString();
    if (messageType != "data") return;

    if (!jsonObject.contains("device") || !jsonObject.contains("metrics")) return;

    QJsonObject device = jsonObject["device"].toObject();
    QJsonObject metrics = jsonObject["metrics"].toObject();
    QString deviceType = device["type"].toString();

    if (deviceType == "rising") {
        m_rinsingTemperature = metrics["temperature"].toDouble();
        m_rinsingFlow = metrics["flow"].toDouble();
        m_rinsingPH = metrics["PH"].toDouble();
        emit rinsingTemperatureChanged();
        emit rinsingFlowChanged();
        emit rinsingPHChanged();
    }
    else if (deviceType == "filling") {
        m_fillingLevel = metrics["level"].toDouble();
        m_fillingFlow = metrics["flow"].toDouble();
        m_fillingPressure = metrics["pressure"].toDouble();
        m_fillingWeight = metrics["weight"].toDouble();
        emit fillingLevelChanged();
        emit fillingFlowChanged();
        emit fillingPressureChanged();
        emit fillingWeightChanged();
    }
    else if (deviceType == "capping") {
        m_cappingTorque = metrics["torque"].toDouble();
        m_cappingCount = metrics["count"].toInt();
        emit cappingTorqueChanged();
        emit cappingCountChanged();
    }
    else if (deviceType == "labeling") {
        m_labelingVision = metrics["vision"].toBool() ? "OK" : "FAIL";
        m_labelingCount = metrics["count"].toInt();
        m_labelingPosition = metrics["position"].toDouble();
        emit labelingVisionChanged();
        emit labelingCountChanged();
        emit labelingPositionChanged();
    }
    else if (deviceType == "packing") {
        m_packingCount = metrics["count"].toInt();
        m_packingWeight = metrics["weight"].toDouble();
        emit packingCountChanged();
        emit packingWeightChanged();
    }
}
