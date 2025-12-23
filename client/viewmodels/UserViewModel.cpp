#include "UserViewModel.h"

UserViewModel::UserViewModel(QObject* parent)
    : QObject(parent)
{
    connect(&m_service, &UserService::usersLoaded,
            this, &UserViewModel::handleUsersLoaded);
    connect(&m_service, &UserService::userAdded,
            this, &UserViewModel::handleUserAdded);
    connect(&m_service, &UserService::userDeleted,
            this, &UserViewModel::handleUserDeleted);
    connect(&m_service, &UserService::error,
            this, &UserViewModel::handleError);
}

void UserViewModel::load() {
    m_service.loadUsers();
}

void UserViewModel::addUser(const QString& name, quint64 departmentId, quint64 roleId) {
    m_service.addUser(name, departmentId, roleId);
}

void UserViewModel::deleteUser(quint64 id) {
    m_service.deleteUser(id);
}

void UserViewModel::handleUsersLoaded(const QVector<UserDto>& users) {
    m_users.clear();
    
    for (const auto& user : users) {
        QVariantMap userMap;
        userMap["id"] = QVariant::fromValue(user.id);
        userMap["name"] = user.name;
        userMap["departmentId"] = QVariant::fromValue(user.departmentId);
        userMap["roleId"] = QVariant::fromValue(user.roleId);
        
        QVariantList pcIds;
        for (const auto& pcId : user.pcIds) {
            pcIds.append(QVariant::fromValue(pcId));
        }
        userMap["pcIds"] = pcIds;
        
        QVariantList installedPoIds;
        for (const auto& poId : user.installedPoIds) {
            installedPoIds.append(QVariant::fromValue(poId));
        }
        userMap["installedPoIds"] = installedPoIds;
        
        m_users.append(userMap);
    }
    
    emit usersChanged();
    emit success("Пользователи загружены");
}

void UserViewModel::handleUserAdded(const UserDto& user) {
    load();
    emit success("Пользователь добавлен");
}

void UserViewModel::handleUserDeleted(quint64 id) {
    load();
    emit success("Пользователь удален");
}

void UserViewModel::handleError(const QString& message) {
    emit error(message);
}