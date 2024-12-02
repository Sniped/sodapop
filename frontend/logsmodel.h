#ifndef LOGSMODEL_H
#define LOGSMODEL_H

#include <QAbstractListModel>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QTimer>

class LogsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum LogRoles {
        TypeRole = Qt::UserRole + 1,
        MessageRole,
        TimestampRole
    };

    explicit LogsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void fetchLogs();

private:
    struct LogEntry {
        QString deviceType;
        QString logType;
        int code;
        QString timestamp;
    };

    QList<LogEntry> m_logs;
    QNetworkAccessManager *m_networkManager;
    QTimer *m_refreshTimer;

    QString getMessageForCode(const QString &deviceType, int code) const;

private slots:
    void handleNetworkReply(QNetworkReply *reply);
};

#endif // LOGSMODEL_H
