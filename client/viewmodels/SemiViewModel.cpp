#include "SemiViewModel.h"

SemiViewModel::SemiViewModel(QObject* parent)
    : QObject(parent)
{
    connect(&m_service, &SemiService::installationsLoaded,
            this, &SemiViewModel::handleInstallationsLoaded);
    connect(&m_service, &SemiService::installationAdded,
            this, &SemiViewModel::handleInstallationAdded);
    connect(&m_service, &SemiService::installationDeleted,
            this, &SemiViewModel::handleInstallationDeleted);
    connect(&m_service, &SemiService::error,
            this, &SemiViewModel::handleError);
}

void SemiViewModel::load() {
    m_service.loadInstallations();
}

void SemiViewModel::addInstallation(quint64 poId, quint64 pcId) {
    m_service.addInstallation(poId, pcId);
}

void SemiViewModel::deleteInstallation(quint64 id) {
    m_service.deleteInstallation(id);
}

void SemiViewModel::handleInstallationsLoaded(const QVector<SemiDto>& installations) {
    m_installations.clear();
    
    for (const auto& installation : installations) {
        QVariantMap instMap;
        instMap["id"] = QVariant::fromValue(installation.id);
        instMap["poId"] = QVariant::fromValue(installation.poId);
        instMap["pcId"] = QVariant::fromValue(installation.pcId);
        
        m_installations.append(instMap);
    }
    
    emit installationsChanged();
    emit success("Установки загружены");
}

void SemiViewModel::handleInstallationAdded(const SemiDto& installation) {
    load();
    emit success("Установка добавлена");
}

void SemiViewModel::handleInstallationDeleted(quint64 id) {
    load();
    emit success("Установка удалена");
}

void SemiViewModel::handleError(const QString& message) {
    emit error(message);
}