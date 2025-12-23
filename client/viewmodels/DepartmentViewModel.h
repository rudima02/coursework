#pragma once
#include <QObject>
#include <QVariantList>
#include "../services/DepartmentService.h"

class DepartmentViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList departments READ departments NOTIFY departmentsChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit DepartmentViewModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void addDepartment(const QString& name);
    Q_INVOKABLE void deleteDepartment(quint64 id);
    
    QVariantList departments() const { return m_departments; }
    bool isLoading() const { return m_service.isLoading(); }

signals:
    void departmentsChanged();
    void isLoadingChanged();
    void error(const QString& message);
    void success(const QString& message);

private:
    DepartmentService m_service;
    QVariantList m_departments;

private slots:
    void handleDepartmentsLoaded(const QVector<DepartmentDto>& departments);
    void handleDepartmentAdded(const DepartmentDto& department);
    void handleDepartmentDeleted(quint64 id);
    void handleError(const QString& message);
};