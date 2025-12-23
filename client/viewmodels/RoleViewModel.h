#pragma once
#include <QObject>
#include <QVariantList>
#include "../services/RoleService.h"

class RoleViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList roles READ roles NOTIFY rolesChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit RoleViewModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void addRole(const QString& name);
    Q_INVOKABLE void deleteRole(quint64 id);
    
    QVariantList roles() const { return m_roles; }
    bool isLoading() const { return m_service.isLoading(); }

signals:
    void rolesChanged();
    void isLoadingChanged();
    void error(const QString& message);
    void success(const QString& message);

private:
    RoleService m_service;
    QVariantList m_roles;

private slots:
    void handleRolesLoaded(const QVector<RoleDto>& roles);
    void handleRoleAdded(const RoleDto& role);
    void handleRoleDeleted(quint64 id);
    void handleError(const QString& message);
};