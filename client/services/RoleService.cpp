#include "RoleService.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

RoleService::RoleService(QObject* parent)
    : QObject(parent)
{
    connect(&m_api, &ApiClient::requestSuccess, this, &RoleService::handleGetSuccess);
    connect(&m_api, &ApiClient::requestError, this, &RoleService::handleError);
}

void RoleService::loadRoles() {
    m_api.get("/roles");
}

void RoleService::addRole(const QString& name) {
    QJsonObject data;
    data["name"] = name;
    
    m_api.post("/roles", data);
    connect(&m_api, &ApiClient::requestSuccess, this, &RoleService::handlePostSuccess, Qt::UniqueConnection);
}

void RoleService::deleteRole(quint64 id) {
    QString endpoint = "/roles/" + QString::number(id);
    m_api.deleteResource(endpoint);
}

void RoleService::handleGetSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/roles") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonArray arr = doc.array();
        
        QVector<RoleDto> roles;
        for (const auto& v : arr) {
            roles.append(RoleDto::fromJson(v.toObject()));
        }
        
        emit rolesLoaded(roles);
    }
}

void RoleService::handlePostSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/roles") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        RoleDto role = RoleDto::fromJson(doc.object());
        emit roleAdded(role);
    }
}

void RoleService::handleError(const QString& errorMsg, const QString& endpoint) {
    Q_UNUSED(endpoint)
    emit error(errorMsg);
}