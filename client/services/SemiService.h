#pragma once
#include <QObject>
#include <QVector>
#include "../network/ApiClient.h"
#include "../dto/SemiDto.h"

class SemiService : public QObject {
    Q_OBJECT
public:
    explicit SemiService(QObject* parent = nullptr);
    
    void loadInstallations();
    void addInstallation(quint64 poId, quint64 pcId);
    void deleteInstallation(quint64 id);
    bool isLoading() const { return m_api.isLoading(); }

signals:
    void installationsLoaded(const QVector<SemiDto>& installations);
    void installationAdded(const SemiDto& installation);
    void installationDeleted(quint64 id);
    void error(const QString& message);

private:
    ApiClient m_api;

private slots:
    void handleGetSuccess(const QByteArray& data, const QString& endpoint);
    void handlePostSuccess(const QByteArray& data, const QString& endpoint);
    void handleError(const QString& error, const QString& endpoint);
};