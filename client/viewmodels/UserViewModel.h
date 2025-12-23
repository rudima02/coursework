#pragma once
#include <QObject>
#include <QVariantList>
#include "../services/UserService.h"

class UserViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList users READ users NOTIFY usersChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit UserViewModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void addUser(const QString& name, quint64 departmentId, quint64 roleId);
    Q_INVOKABLE void deleteUser(quint64 id);
    
    QVariantList users() const { return m_users; }
    bool isLoading() const { return m_service.isLoading(); }

signals:
    void usersChanged();
    void isLoadingChanged();
    void error(const QString& message);
    void success(const QString& message);

private:
    UserService m_service;
    QVariantList m_users;

private slots:
    void handleUsersLoaded(const QVector<UserDto>& users);
    void handleUserAdded(const UserDto& user);
    void handleUserDeleted(quint64 id);
    void handleError(const QString& message);
};