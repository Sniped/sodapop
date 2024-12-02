#include "logsmodel.h"
#include <QDateTime>

LogsModel::LogsModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_refreshTimer(new QTimer(this))
{
    connect(m_networkManager, &QNetworkAccessManager::finished,
            this, &LogsModel::handleNetworkReply);

    // Refresh logs every 5 seconds
    m_refreshTimer->setInterval(5000);
    connect(m_refreshTimer, &QTimer::timeout, this, &LogsModel::fetchLogs);
    m_refreshTimer->start();

    // Initial fetch
    fetchLogs();
}

int LogsModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_logs.size();
}

QVariant LogsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const LogEntry &entry = m_logs.at(index.row());

    switch (role) {
    case TypeRole:
        return entry.logType;
    case MessageRole:
        return QString("%1: %2")
            .arg(entry.deviceType.toUpper())
            .arg(getMessageForCode(entry.deviceType, entry.code));
    case TimestampRole:
        return entry.timestamp;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> LogsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TypeRole] = "type";
    roles[MessageRole] = "message";
    roles[TimestampRole] = "timestamp";
    return roles;
}

void LogsModel::fetchLogs()
{
    QNetworkRequest request(QUrl("https://sodapop.colin.gg/logs"));
    request.setRawHeader("Authorization", "e48y5QfmnJSCae5gMJsd");
    m_networkManager->get(request);
}

void LogsModel::handleNetworkReply(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        QJsonArray logs = doc.array();

        beginResetModel();
        m_logs.clear();

        for (const QJsonValue &value : logs) {
            QJsonObject log = value.toObject();
            LogEntry entry;
            entry.deviceType = log["deviceType"].toString();
            entry.logType = log["logType"].toString().toUpper();
            entry.code = log["code"].toInt();

            QDateTime timestamp = QDateTime::fromString(
                log["createdAt"].toString(),
                Qt::ISODate
                );
            entry.timestamp = timestamp.toString("hh:mm:ss");

            m_logs.append(entry);
        }

        endResetModel();
    }
    reply->deleteLater();
}

QString LogsModel::getMessageForCode(const QString &deviceType, int code) const
{
    // Define messages for different device types and error codes
    if (deviceType == "rising") {
        switch (code) {
        case 1: return "System startup initiated";
        case 2: return "Temperature warning";
        case 3: return "Motor malfunction";
        case 4: return "Pressure threshold exceeded";
        default: return "Unknown error";
        }
    }
    else if (deviceType == "filling") {
        switch (code) {
        case 2: return "Tank level low";
        case 4: return "Flow rate irregular";
        default: return "Unknown error";
        }
    }
    // Add more device types and codes as needed
    return "Unknown message";
}
