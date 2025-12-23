#pragma once

#include <QObject>
#include <QVector>
#include <QVariant>
#include "network/ApiClient.h"
#include "dto/CategoryDto.h"
#include "dto/DepartmentDto.h"
#include "dto/PoDto.h"
#include "dto/PcDto.h"
#include "dto/UserDto.h"

class MainViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList categories READ categories NOTIFY categoriesChanged)
    Q_PROPERTY(QVariantList departments READ departments NOTIFY departmentsChanged)
    Q_PROPERTY(QVariantList programs READ programs NOTIFY programsChanged)
    Q_PROPERTY(QVariantList computers READ computers NOTIFY computersChanged)
    Q_PROPERTY(QVariantList users READ users NOTIFY usersChanged)
    Q_PROPERTY(QString baseUrl READ baseUrl WRITE setBaseUrl NOTIFY baseUrlChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit MainViewModel(QObject* parent = nullptr);
    
    QVariantList categories() const { return m_categories; }
    QVariantList departments() const { return m_departments; }
    QVariantList programs() const { return m_programs; }
    QVariantList computers() const { return m_computers; }
    QVariantList users() const { return m_users; }
    QString baseUrl() const { return m_api.baseUrl(); }
    bool isLoading() const { return m_api.isLoading(); }

    void setBaseUrl(const QString& url) { m_api.setBaseUrl(url); }

    Q_INVOKABLE void loadInitialData();
    Q_INVOKABLE void addCategory(const QString& name);
    Q_INVOKABLE void addDepartment(const QString& name);
    Q_INVOKABLE void addProgram(const QString& name, quint64 categoryId);
    Q_INVOKABLE void addComputer(const QString& name, quint64 departmentId);
    Q_INVOKABLE void addUser(const QString& name, quint64 departmentId, quint64 roleId);
    Q_INVOKABLE void installProgram(quint64 pcId, quint64 poId);
    Q_INVOKABLE void updatePoCount(quint64 poId, quint64 count);

signals:
    void categoriesChanged();
    void departmentsChanged();
    void programsChanged();
    void computersChanged();
    void usersChanged();
    void baseUrlChanged();
    void isLoadingChanged();
    void errorOccurred(const QString& message);
    void success(const QString& message);

private:
    ApiClient m_api;
    QVariantList m_categories;
    QVariantList m_departments;
    QVariantList m_programs;
    QVariantList m_computers;
    QVariantList m_users;

    void loadCategories();
    void loadDepartments();
    void loadPrograms();
    void loadComputers();
    void loadUsers();
};