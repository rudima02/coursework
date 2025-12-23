#pragma once
#include <QObject>
#include <QVector>
#include "../network/ApiClient.h"
#include "../dto/RoleDto.h"

class RoleService : public QObject {
    Q_OBJECT
public:
    explicit RoleService(QObject* parent = nullptr);
    
    void loadRoles();
    void addRole(const QString& name);
    void deleteRole(quint64 id);
    bool isLoading() const { return m_api.isLoading(); }

signals:
    void rolesLoaded(const QVector<RoleDto>& roles);
    void roleAdded(const RoleDto& role);
    void roleDeleted(quint64 id);
    void error(const QString& message);

private:
    ApiClient m_api;

private slots:
    void handleGetSuccess(const QByteArray& data, const QString& endpoint);
    void handlePostSuccess(const QByteArray& data, const QString& endpoint);
    void handleError(const QString& error, const QString& endpoint);
};