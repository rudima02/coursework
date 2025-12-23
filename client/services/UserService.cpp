#include "UserService.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

UserService::UserService(QObject* parent)
    : QObject(parent)
{
    connect(&m_api, &ApiClient::requestSuccess, this, &UserService::handleGetSuccess);
    connect(&m_api, &ApiClient::requestError, this, &UserService::handleError);
}

void UserService::loadUsers() {
    m_api.get("/users");
}

void UserService::addUser(const QString& name, quint64 departmentId, quint64 roleId) {
    QJsonObject data;
    data["name"] = name;
    data["department_id"] = static_cast<double>(departmentId);  
    data["role_id"] = static_cast<double>(roleId);
    
    m_api.post("/users", data);
    connect(&m_api, &ApiClient::requestSuccess, this, &UserService::handlePostSuccess, Qt::UniqueConnection);
}

void UserService::deleteUser(quint64 id) {
    QString endpoint = "/users/" + QString::number(id);
    m_api.deleteResource(endpoint);
}

void UserService::handleGetSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/users") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonArray arr = doc.array();
        
        QVector<UserDto> users;
        for (const auto& v : arr) {
            users.append(UserDto::fromJson(v.toObject()));
        }
        
        emit usersLoaded(users);
    }
}

void UserService::handlePostSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/users") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        UserDto user = UserDto::fromJson(doc.object());
        emit userAdded(user);
    }
}

void UserService::handleError(const QString& errorMsg, const QString& endpoint) {
    Q_UNUSED(endpoint)
    emit error(errorMsg);
}