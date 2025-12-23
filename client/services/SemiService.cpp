#include "SemiService.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

SemiService::SemiService(QObject* parent)
    : QObject(parent)
{
    connect(&m_api, &ApiClient::requestSuccess, this, &SemiService::handleGetSuccess);
    connect(&m_api, &ApiClient::requestError, this, &SemiService::handleError);
}

void SemiService::loadInstallations() {
    m_api.get("/semis");
}

void SemiService::addInstallation(quint64 poId, quint64 pcId) {
    QJsonObject data;
    data["po_id"] = static_cast<double>(poId); 
    data["pc_id"] = static_cast<double>(pcId);  
    m_api.post("/semis", data);
    connect(&m_api, &ApiClient::requestSuccess, this, &SemiService::handlePostSuccess, Qt::UniqueConnection);
}

void SemiService::deleteInstallation(quint64 id) {
    QString endpoint = "/semis/" + QString::number(id);
    m_api.deleteResource(endpoint);
}

void SemiService::handleGetSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/semis") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonArray arr = doc.array();
        
        QVector<SemiDto> installations;
        for (const auto& v : arr) {
            installations.append(SemiDto::fromJson(v.toObject()));
        }
        
        emit installationsLoaded(installations);
    }
}

void SemiService::handlePostSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/semis") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        SemiDto installation = SemiDto::fromJson(doc.object());
        emit installationAdded(installation);
    }
}

void SemiService::handleError(const QString& errorMsg, const QString& endpoint) {
    Q_UNUSED(endpoint)
    emit error(errorMsg);
}