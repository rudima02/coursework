#pragma once
#include <QObject>
#include <QVariantList>
#include "../services/VersionPoService.h"

class VersionPoViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList versions READ versions NOTIFY versionsChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit VersionPoViewModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void addVersion(const QString& version, const QString& date, quint64 poId);
    Q_INVOKABLE void deleteVersion(quint64 id);
    
    QVariantList versions() const { return m_versions; }
    bool isLoading() const { return m_service.isLoading(); }

signals:
    void versionsChanged();
    void isLoadingChanged();
    void error(const QString& message);
    void success(const QString& message);

private:
    VersionPoService m_service;
    QVariantList m_versions;

private slots:
    void handleVersionsLoaded(const QVector<VersionPoDto>& versions);
    void handleVersionAdded(const VersionPoDto& version);
    void handleVersionDeleted(quint64 id);
    void handleError(const QString& message);
};