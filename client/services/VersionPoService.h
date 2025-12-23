#pragma once
#include <QObject>
#include <QVector>
#include "../network/ApiClient.h"
#include "../dto/VersionPoDto.h"

class VersionPoService : public QObject {
    Q_OBJECT
public:
    explicit VersionPoService(QObject* parent = nullptr);
    
    void loadVersions();
    void addVersion(const QString& version, const QString& date, quint64 poId);
    void deleteVersion(quint64 id);
    bool isLoading() const { return m_api.isLoading(); }

signals:
    void versionsLoaded(const QVector<VersionPoDto>& versions);
    void versionAdded(const VersionPoDto& version);
    void versionDeleted(quint64 id);
    void error(const QString& message);

private:
    ApiClient m_api;

private slots:
    void handleGetSuccess(const QByteArray& data, const QString& endpoint);
    void handlePostSuccess(const QByteArray& data, const QString& endpoint);
    void handleError(const QString& error, const QString& endpoint);
};