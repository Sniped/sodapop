#include "datamanager.h"

DataManager::DataManager(QObject *parent) : QObject(parent), m_currentValue(0.0) {
    connect(&m_webSocket, &QWebSocket::connected, this, &DataManager::onConnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &DataManager::onMessageReceived);

    // Replace with your WebSocket server URL
    m_webSocket.open(QUrl("ws://your-server-url:port"));
}

void DataManager::onConnected() {
    qDebug() << "WebSocket connected";
}

void DataManager::onMessageReceived(const QString &message) {
    bool ok;
    double value = message.toDouble(&ok);
    if (ok) {
        m_currentValue = value;
        emit currentValueChanged();
    }
}
