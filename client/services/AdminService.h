#pragma once
#include <QObject>
#include <QVariantList>
#include "../network/ApiClient.h"

class AdminService : public QObject {
    Q_OBJECT
public:
    explicit AdminService(QObject* parent = nullptr);

    void bulkAdd(const QVariantList& departmentIds, int pcsPerDepartment, int poId);

signals:
    void success();
    void error(const QString& msg);

private:
    ApiClient m_api;
};
