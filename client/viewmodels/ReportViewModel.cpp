#include "ReportViewModel.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

ReportViewModel::ReportViewModel(QObject* parent)
    : QObject(parent)
{
    connect(&m_service, &ReportService::reportsLoaded,
            this, &ReportViewModel::parse);
    connect(&m_service, &ReportService::error,
            this, &ReportViewModel::error);
}

void ReportViewModel::load() {
    m_isLoading = true;
    emit isLoadingChanged();
    m_service.load();
}

void ReportViewModel::parse(const QByteArray& data) {
    m_departments.clear();

    QJsonObject root = QJsonDocument::fromJson(data).object();

    for (const auto& d : root["departments"].toArray()) {
        QJsonObject obj = d.toObject();
        QVariantMap dept;

        dept["name"] = obj["name"].toString();

        int pcCount = obj["pcs"].toArray().size();
        int poCount = 0;
        for (const auto& pc : obj["pcs"].toArray())
            poCount += pc.toObject()["installed_software"].toArray().size();

        int userCount = obj["users"].toArray().size();

        dept["pcCount"] = pcCount;
        dept["poCount"] = poCount;
        dept["userCount"] = userCount;

        m_departments.append(dept);
    }

    QJsonObject s = root["summary"].toObject();
    m_totalPc = s["total_pcs"].toInt();
    m_totalPo = s["total_software"].toInt();
    m_totalUsers = s["total_users"].toInt();

    m_isLoading = false;

    emit departmentsChanged();
    emit summaryChanged();
    emit isLoadingChanged();
    emit success("Отчёт загружен");
}
