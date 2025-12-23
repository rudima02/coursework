#pragma once
#include <QObject>
#include "./network/ApiClient.h"

class ReportService : public QObject {
    Q_OBJECT
public:
    explicit ReportService(QObject* parent = nullptr);

    void load();

signals:
    void reportsLoaded(const QByteArray& data);
    void error(const QString& msg);

private:
    ApiClient m_api;

    void handleSuccess(const QByteArray& data, const QString& endpoint);
    void handleError(const QString& msg, const QString& endpoint);
};
