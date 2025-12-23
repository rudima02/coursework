#pragma once
#include <QObject>
#include <QVariantList>
#include "../services/SemiService.h"

class SemiViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList installations READ installations NOTIFY installationsChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit SemiViewModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void addInstallation(quint64 poId, quint64 pcId);
    Q_INVOKABLE void deleteInstallation(quint64 id);
    
    QVariantList installations() const { return m_installations; }
    bool isLoading() const { return m_service.isLoading(); }

signals:
    void installationsChanged();
    void isLoadingChanged();
    void error(const QString& message);
    void success(const QString& message);

private:
    SemiService m_service;
    QVariantList m_installations;

private slots:
    void handleInstallationsLoaded(const QVector<SemiDto>& installations);
    void handleInstallationAdded(const SemiDto& installation);
    void handleInstallationDeleted(quint64 id);
    void handleError(const QString& message);
};

