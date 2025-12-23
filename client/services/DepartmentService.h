#pragma once
#include <QObject>
#include <QVector>
#include "../network/ApiClient.h"
#include "../dto/DepartmentDto.h"

class DepartmentService : public QObject {
    Q_OBJECT
public:
    explicit DepartmentService(QObject* parent = nullptr);
    
    void loadDepartments();
    void addDepartment(const QString& name);
    void deleteDepartment(quint64 id);
    bool isLoading() const { return m_api.isLoading(); }

signals:
    void departmentsLoaded(const QVector<DepartmentDto>& departments);
    void departmentAdded(const DepartmentDto& department);
    void departmentDeleted(quint64 id);
    void error(const QString& message);

private:
    ApiClient m_api;

private slots:
    void handleGetSuccess(const QByteArray& data, const QString& endpoint);
    void handlePostSuccess(const QByteArray& data, const QString& endpoint);
    void handleError(const QString& error, const QString& endpoint);
};