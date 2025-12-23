#include "VersionPoViewModel.h"

VersionPoViewModel::VersionPoViewModel(QObject* parent)
    : QObject(parent)
{
    connect(&m_service, &VersionPoService::versionsLoaded,
            this, &VersionPoViewModel::handleVersionsLoaded);
    connect(&m_service, &VersionPoService::versionAdded,
            this, &VersionPoViewModel::handleVersionAdded);
    connect(&m_service, &VersionPoService::versionDeleted,
            this, &VersionPoViewModel::handleVersionDeleted);
    connect(&m_service, &VersionPoService::error,
            this, &VersionPoViewModel::handleError);
}

void VersionPoViewModel::load() {
    m_service.loadVersions();
}

void VersionPoViewModel::addVersion(const QString& version, const QString& date, quint64 poId) {
    m_service.addVersion(version, date, poId);
}

void VersionPoViewModel::deleteVersion(quint64 id) {
    m_service.deleteVersion(id);
}

void VersionPoViewModel::handleVersionsLoaded(const QVector<VersionPoDto>& versions) {
    m_versions.clear();
    
    for (const auto& version : versions) {
        QVariantMap verMap;
        verMap["id"] = QVariant::fromValue(version.id);
        verMap["version"] = version.version;
        verMap["dateVersion"] = version.dateVersion;
        verMap["poId"] = QVariant::fromValue(version.poId);
        
        m_versions.append(verMap);
    }
    
    emit versionsChanged();
    emit success("Версии ПО загружены");
}

void VersionPoViewModel::handleVersionAdded(const VersionPoDto& version) {
    load();
    emit success("Версия добавлена");
}

void VersionPoViewModel::handleVersionDeleted(quint64 id) {
    load();
    emit success("Версия удалена");
}

void VersionPoViewModel::handleError(const QString& message) {
    emit error(message);
}