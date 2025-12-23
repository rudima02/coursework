#pragma once
#include <QObject>
#include <QVector>
#include "../network/ApiClient.h"
#include "../dto/PcDto.h"

class PcService : public QObject {
    Q_OBJECT
public:
    explicit PcService(QObject* parent = nullptr);
    
    void loadComputers();
    void addComputer(const QString& name, quint64 departmentId);
    void deleteComputer(quint64 id);
    bool isLoading() const { return m_api.isLoading(); }

signals:
    void computersLoaded(const QVector<PcDto>& computers);
    void computerAdded(const PcDto& computer);
    void computerDeleted(quint64 id);
    void error(const QString& message);

private:
    ApiClient m_api;

private slots:
    void handleGetSuccess(const QByteArray& data, const QString& endpoint);
    void handlePostSuccess(const QByteArray& data, const QString& endpoint);
    void handleError(const QString& error, const QString& endpoint);
};