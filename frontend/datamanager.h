// datamanager.h
#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QWebSocket>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkRequest>

class DataManager : public QObject
{
    Q_OBJECT

public:
    explicit DataManager(QObject *parent = nullptr);
    void connectToServer();

private slots:
    void onConnected();
    void onDisconnected();
    void onTextMessageReceived(const QString &message);

private:
    QWebSocket m_webSocket;
    void parseDeviceData(const QJsonObject &data);
};

#endif // DATAMANAGER_H
