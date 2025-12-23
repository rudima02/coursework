#include "RoleViewModel.h"

RoleViewModel::RoleViewModel(QObject* parent)
    : QObject(parent)
{
    connect(&m_service, &RoleService::rolesLoaded,
            this, &RoleViewModel::handleRolesLoaded);
    connect(&m_service, &RoleService::roleAdded,
            this, &RoleViewModel::handleRoleAdded);
    connect(&m_service, &RoleService::roleDeleted,
            this, &RoleViewModel::handleRoleDeleted);
    connect(&m_service, &RoleService::error,
            this, &RoleViewModel::handleError);
}

void RoleViewModel::load() {
    m_service.loadRoles();
}

void RoleViewModel::addRole(const QString& name) {
    m_service.addRole(name);
}

void RoleViewModel::deleteRole(quint64 id) {
    m_service.deleteRole(id);
}

void RoleViewModel::handleRolesLoaded(const QVector<RoleDto>& roles) {
    m_roles.clear();
    
    for (const auto& role : roles) {
        QVariantMap roleMap;
        roleMap["id"] = QVariant::fromValue(role.id);
        roleMap["name"] = role.name;
        
        QVariantList userIds;
        for (const auto& userId : role.userIds) {
            userIds.append(QVariant::fromValue(userId));
        }
        roleMap["userIds"] = userIds;
        
        m_roles.append(roleMap);
    }
    
    emit rolesChanged();
    emit success("Роли загружены");
}

void RoleViewModel::handleRoleAdded(const RoleDto& role) {
    load();
    emit success("Роль добавлена");
}

void RoleViewModel::handleRoleDeleted(quint64 id) {
    load();
    emit success("Роль удалена");
}

void RoleViewModel::handleError(const QString& message) {
    emit error(message);
}