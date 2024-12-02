/*
#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QWebSocket>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QDebug>

class DataManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList messages READ messages NOTIFY messagesChanged)

public:
    explicit DataManager(QObject *parent = nullptr);
    void start();

    QStringList messages() const;

signals:
    void messagesChanged();

private slots:
    void onConnected();
    void onTextMessageReceived(const QString &message);

private:
    QWebSocket m_webSocket;
    QStringList m_messages;
};

#endif // DATAMANAGER_H
*/

// DataManager.h
#ifndef DATAMANAGER_H
#define DATAMANAGER_H
#include <QObject>
#include <QWebSocket>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QDebug>

class DataManager : public QObject
{
    Q_OBJECT
    // Rinsing Machine Properties
    Q_PROPERTY(double rinsingTemperature READ rinsingTemperature NOTIFY rinsingTemperatureChanged)
    Q_PROPERTY(double rinsingFlow READ rinsingFlow NOTIFY rinsingFlowChanged)
    Q_PROPERTY(double rinsingPH READ rinsingPH NOTIFY rinsingPHChanged)

    // Filling Machine Properties
    Q_PROPERTY(double fillingLevel READ fillingLevel NOTIFY fillingLevelChanged)
    Q_PROPERTY(double fillingFlow READ fillingFlow NOTIFY fillingFlowChanged)
    Q_PROPERTY(double fillingPressure READ fillingPressure NOTIFY fillingPressureChanged)
    Q_PROPERTY(double fillingWeight READ fillingWeight NOTIFY fillingWeightChanged)

    // Capping Machine Properties
    Q_PROPERTY(double cappingTorque READ cappingTorque NOTIFY cappingTorqueChanged)
    Q_PROPERTY(int cappingCount READ cappingCount NOTIFY cappingCountChanged)

    // Labeling Machine Properties
    Q_PROPERTY(QString labelingVision READ labelingVision NOTIFY labelingVisionChanged)
    Q_PROPERTY(int labelingCount READ labelingCount NOTIFY labelingCountChanged)
    Q_PROPERTY(double labelingPosition READ labelingPosition NOTIFY labelingPositionChanged)

    // Packing Machine Properties
    Q_PROPERTY(int packingCount READ packingCount NOTIFY packingCountChanged)
    Q_PROPERTY(double packingWeight READ packingWeight NOTIFY packingWeightChanged)

public:
    explicit DataManager(QObject *parent = nullptr);
    Q_INVOKABLE void start();

    // Getters for all properties
    double rinsingTemperature() const { return m_rinsingTemperature; }
    double rinsingFlow() const { return m_rinsingFlow; }
    double rinsingPH() const { return m_rinsingPH; }

    double fillingLevel() const { return m_fillingLevel; }
    double fillingFlow() const { return m_fillingFlow; }
    double fillingPressure() const { return m_fillingPressure; }
    double fillingWeight() const { return m_fillingWeight; }

    double cappingTorque() const { return m_cappingTorque; }
    int cappingCount() const { return m_cappingCount; }

    QString labelingVision() const { return m_labelingVision; }
    int labelingCount() const { return m_labelingCount; }
    double labelingPosition() const { return m_labelingPosition; }

    int packingCount() const { return m_packingCount; }
    double packingWeight() const { return m_packingWeight; }

signals:
    // Signals for all properties
    void rinsingTemperatureChanged();
    void rinsingFlowChanged();
    void rinsingPHChanged();

    void fillingLevelChanged();
    void fillingFlowChanged();
    void fillingPressureChanged();
    void fillingWeightChanged();

    void cappingTorqueChanged();
    void cappingCountChanged();

    void labelingVisionChanged();
    void labelingCountChanged();
    void labelingPositionChanged();

    void packingCountChanged();
    void packingWeightChanged();

private slots:
    void onConnected();
    void onTextMessageReceived(const QString &message);

private:
    QWebSocket m_webSocket;

    // Private member variables for all properties
    double m_rinsingTemperature = 0.0;
    double m_rinsingFlow = 0.0;
    double m_rinsingPH = 0.0;

    double m_fillingLevel = 0.0;
    double m_fillingFlow = 0.0;
    double m_fillingPressure = 0.0;
    double m_fillingWeight = 0.0;

    double m_cappingTorque = 0.0;
    int m_cappingCount = 0;

    QString m_labelingVision = "N/A";
    int m_labelingCount = 0;
    double m_labelingPosition = 0.0;

    int m_packingCount = 0;
    double m_packingWeight = 0.0;
};

#endif // DATAMANAGER_H
