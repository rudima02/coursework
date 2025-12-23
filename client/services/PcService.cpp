#include "PcService.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

PcService::PcService(QObject* parent)
    : QObject(parent)
{
    connect(&m_api, &ApiClient::requestSuccess, this, &PcService::handleGetSuccess);
    connect(&m_api, &ApiClient::requestError, this, &PcService::handleError);
}

void PcService::loadComputers() {
    m_api.get("/pc");
}

void PcService::addComputer(const QString& name, quint64 departmentId) {
    QJsonObject data;
    data["name"] = name;
    data["department_id"] = static_cast<double>(departmentId);
    qDebug() << "Sending PC data:" << QJsonDocument(data).toJson();
    
    m_api.post("/pc", data);
    connect(&m_api, &ApiClient::requestSuccess, this, &PcService::handlePostSuccess, Qt::UniqueConnection);
}
void PcService::deleteComputer(quint64 id) {
    QString endpoint = "/pc/" + QString::number(id);
    m_api.deleteResource(endpoint);
}

void PcService::handleGetSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/pc") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonArray arr = doc.array();
        
        QVector<PcDto> computers;
        for (const auto& v : arr) {
            computers.append(PcDto::fromJson(v.toObject()));
        }
        
        emit computersLoaded(computers);
    }
}

void PcService::handlePostSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/pc") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        PcDto computer = PcDto::fromJson(doc.object());
        emit computerAdded(computer);
    }
}

void PcService::handleError(const QString& errorMsg, const QString& endpoint) {
    Q_UNUSED(endpoint)
    emit error(errorMsg);
}