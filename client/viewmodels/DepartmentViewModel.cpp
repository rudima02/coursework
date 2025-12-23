#include "DepartmentViewModel.h"

DepartmentViewModel::DepartmentViewModel(QObject* parent)
    : QObject(parent)
{
    connect(&m_service, &DepartmentService::departmentsLoaded,
            this, &DepartmentViewModel::handleDepartmentsLoaded);
    connect(&m_service, &DepartmentService::departmentAdded,
            this, &DepartmentViewModel::handleDepartmentAdded);
    connect(&m_service, &DepartmentService::departmentDeleted,
            this, &DepartmentViewModel::handleDepartmentDeleted);
    connect(&m_service, &DepartmentService::error,
            this, &DepartmentViewModel::handleError);
}

void DepartmentViewModel::load() {
    m_service.loadDepartments();
}

void DepartmentViewModel::addDepartment(const QString& name) {
    m_service.addDepartment(name);
}

void DepartmentViewModel::deleteDepartment(quint64 id) {
    m_service.deleteDepartment(id);
}

void DepartmentViewModel::handleDepartmentsLoaded(const QVector<DepartmentDto>& departments) {
    m_departments.clear();
    
    for (const auto& department : departments) {
        QVariantMap deptMap;
        deptMap["id"] = QVariant::fromValue(department.id);
        deptMap["name"] = department.name;
        
        QVariantList pcs;
        for (const auto& pc : department.pcs) {
            QVariantMap pcMap;
            pcMap["id"] = QVariant::fromValue(pc.id);
            pcMap["name"] = pc.name;
            pcMap["departmentId"] = QVariant::fromValue(pc.departmentId);
            pcs.append(pcMap);
        }
        deptMap["pcs"] = pcs;
        
        QVariantList users;
        for (const auto& userId : department.users) {
            users.append(QVariant::fromValue(userId));
        }
        deptMap["users"] = users;
        
        m_departments.append(deptMap);
    }
    
    emit departmentsChanged();
    emit success("Отделы загружены");
}

void DepartmentViewModel::handleDepartmentAdded(const DepartmentDto& department) {
    load();
    emit success("Отдел добавлен");
}

void DepartmentViewModel::handleDepartmentDeleted(quint64 id) {
    load();
    emit success("Отдел удален");
}

void DepartmentViewModel::handleError(const QString& message) {
    emit error(message);
}