#include "ReportService.h"

ReportService::ReportService(QObject* parent)
    : QObject(parent)
{
    connect(&m_api, &ApiClient::requestSuccess,
            this, &ReportService::handleSuccess);
    connect(&m_api, &ApiClient::requestError,
            this, &ReportService::handleError);
}

void ReportService::load() {
    m_api.get("/reports");
}

void ReportService::handleSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/reports") {
        emit reportsLoaded(data);
    }
}

void ReportService::handleError(const QString& msg, const QString&) {
    emit error(msg);
}
