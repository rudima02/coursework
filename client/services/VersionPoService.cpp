#include "VersionPoService.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

VersionPoService::VersionPoService(QObject* parent)
    : QObject(parent)
{
    connect(&m_api, &ApiClient::requestSuccess, this, &VersionPoService::handleGetSuccess);
    connect(&m_api, &ApiClient::requestError, this, &VersionPoService::handleError);
}

void VersionPoService::loadVersions() {
    m_api.get("/versionpos");
}

void VersionPoService::addVersion(const QString& version, const QString& date, quint64 poId) {
    QJsonObject data;
    data["version"] = version;
    data["date_version"] = date;
    data["po_id"] = static_cast<double>(poId);

    
    m_api.post("/versionpos", data);
    connect(&m_api, &ApiClient::requestSuccess, this, &VersionPoService::handlePostSuccess, Qt::UniqueConnection);
}

void VersionPoService::deleteVersion(quint64 id) {
    QString endpoint = "/versionpos/" + QString::number(id);
    m_api.deleteResource(endpoint);
}

void VersionPoService::handleGetSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/versionpos") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonArray arr = doc.array();
        
        QVector<VersionPoDto> versions;
        for (const auto& v : arr) {
            versions.append(VersionPoDto::fromJson(v.toObject()));
        }
        
        emit versionsLoaded(versions);
    }
}

void VersionPoService::handlePostSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/versionpos") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        VersionPoDto version = VersionPoDto::fromJson(doc.object());
        emit versionAdded(version);
    }
}

void VersionPoService::handleError(const QString& errorMsg, const QString& endpoint) {
    Q_UNUSED(endpoint)
    emit error(errorMsg);
}