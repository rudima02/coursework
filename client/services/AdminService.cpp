#include "AdminService.h"
#include <QJsonArray>
#include <QJsonObject>

AdminService::AdminService(QObject* parent)
    : QObject(parent)
{
    connect(&m_api, &ApiClient::requestSuccess,
            this, [this](const QByteArray&, const QString& endpoint){
                if (endpoint == "/admin/bulkAddPc")
                    emit success();
            });

    connect(&m_api, &ApiClient::requestError,
            this, [this](const QString& msg, const QString&){
                emit error(msg);
            });
}

void AdminService::bulkAdd(const QVariantList& departmentIds, int pcsPerDepartment, int poId) {
    QJsonObject body;
    body["departmentIds"] = QJsonArray::fromVariantList(departmentIds);
    body["pcsPerDepartment"] = pcsPerDepartment;
    body["poId"] = poId;

    m_api.post("/admin/bulkAddPc", body);
}
