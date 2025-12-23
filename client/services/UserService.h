#pragma once
#include <QObject>
#include <QVector>
#include "../network/ApiClient.h"
#include "../dto/UserDto.h"

class UserService : public QObject {
    Q_OBJECT
public:
    explicit UserService(QObject* parent = nullptr);
    
    void loadUsers();
    void addUser(const QString& name, quint64 departmentId, quint64 roleId);
    void deleteUser(quint64 id);
    bool isLoading() const { return m_api.isLoading(); }

signals:
    void usersLoaded(const QVector<UserDto>& users);
    void userAdded(const UserDto& user);
    void userDeleted(quint64 id);
    void error(const QString& message);

private:
    ApiClient m_api;

private slots:
    void handleGetSuccess(const QByteArray& data, const QString& endpoint);
    void handlePostSuccess(const QByteArray& data, const QString& endpoint);
    void handleError(const QString& error, const QString& endpoint);
};