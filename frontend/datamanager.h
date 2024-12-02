#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QWebSocket>

class DataManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(double currentValue READ currentValue NOTIFY currentValueChanged)

public:
    explicit DataManager(QObject *parent = nullptr);
    double currentValue() const { return m_currentValue; }

signals:
    void currentValueChanged();

private slots:
    void onConnected();
    void onMessageReceived(const QString &message);

private:
    QWebSocket m_webSocket;
    double m_currentValue;
};

#endif // DATAMANAGER_H
