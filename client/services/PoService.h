#pragma once
#include <QObject>
#include <QVector>
#include "../network/ApiClient.h"
#include "../dto/PoDto.h"

class PoService : public QObject {
    Q_OBJECT
public:
    explicit PoService(QObject* parent = nullptr);
    
    void loadPrograms();
    void addProgram(const QString& name, quint64 categoryId);
    void deleteProgram(quint64 id);
    bool isLoading() const { return m_api.isLoading(); }

signals:
    void programsLoaded(const QVector<PoDto>& programs);
    void programAdded(const PoDto& program);
    void programDeleted(quint64 id);
    void error(const QString& message);

private:
    ApiClient m_api;

private slots:
    void handleGetSuccess(const QByteArray& data, const QString& endpoint);
    void handlePostSuccess(const QByteArray& data, const QString& endpoint);
    void handleError(const QString& error, const QString& endpoint);
};