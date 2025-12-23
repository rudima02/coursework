#include "PoService.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

PoService::PoService(QObject* parent)
    : QObject(parent)
{
    connect(&m_api, &ApiClient::requestSuccess, this, &PoService::handleGetSuccess);
    connect(&m_api, &ApiClient::requestError, this, &PoService::handleError);
}

void PoService::loadPrograms() {
    m_api.get("/po");
}

void PoService::addProgram(const QString& name, quint64 categoryId) {
    QJsonObject data;
    data["name"] = name;
    data["category_id"] = static_cast<double>(categoryId); //TODO БД
    
    m_api.post("/po", data);
    connect(&m_api, &ApiClient::requestSuccess, this, &PoService::handlePostSuccess, Qt::UniqueConnection);
}

void PoService::deleteProgram(quint64 id) {
    QString endpoint = "/po/" + QString::number(id);
    m_api.deleteResource(endpoint);
}

void PoService::handleGetSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/po") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonArray arr = doc.array();
        
        QVector<PoDto> programs;
        for (const auto& v : arr) {
            programs.append(PoDto::fromJson(v.toObject()));
        }
        
        emit programsLoaded(programs);
    }
}

void PoService::handlePostSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/po") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        PoDto program = PoDto::fromJson(doc.object());
        emit programAdded(program);
    }
}

void PoService::handleError(const QString& errorMsg, const QString& endpoint) {
    Q_UNUSED(endpoint)
    emit error(errorMsg);
}