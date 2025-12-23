#include "DepartmentService.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

DepartmentService::DepartmentService(QObject* parent)
    : QObject(parent)
{
    connect(&m_api, &ApiClient::requestSuccess, this, &DepartmentService::handleGetSuccess);
    connect(&m_api, &ApiClient::requestError, this, &DepartmentService::handleError);
}

void DepartmentService::loadDepartments() {
    m_api.get("/departments");
}

void DepartmentService::addDepartment(const QString& name) {
    QJsonObject data;
    data["name"] = name;
    
   
    m_api.post("/departments", data);
    connect(&m_api, &ApiClient::requestSuccess, this, &DepartmentService::handlePostSuccess, Qt::UniqueConnection);
}

void DepartmentService::deleteDepartment(quint64 id) {
    QString endpoint = "/departments/" + QString::number(id);
    m_api.deleteResource(endpoint);
}

void DepartmentService::handleGetSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/departments") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonArray arr = doc.array();
        
        QVector<DepartmentDto> departments;
        for (const auto& v : arr) {
            departments.append(DepartmentDto::fromJson(v.toObject()));
        }
        
        emit departmentsLoaded(departments);
    }
}

void DepartmentService::handlePostSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/departments") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        DepartmentDto department = DepartmentDto::fromJson(doc.object());
        emit departmentAdded(department);
    }
}

void DepartmentService::handleError(const QString& errorMsg, const QString& endpoint) {
    Q_UNUSED(endpoint)
    emit error(errorMsg);
}