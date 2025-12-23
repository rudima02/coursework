#pragma once
#include <QObject>
#include <QVariantList>
#include "../services/PcService.h"

class PcViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList computers READ computers NOTIFY computersChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit PcViewModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void addComputer(const QString& name, quint64 departmentId);
    Q_INVOKABLE void deleteComputer(quint64 id);
    
    Q_INVOKABLE QString getDepartmentName(quint64 departmentId) const;
    Q_INVOKABLE QString getComputerDisplayName(quint64 computerId) const;
    
    QVariantList computers() const { return m_computers; }
    bool isLoading() const { return m_service.isLoading(); }

signals:
    void computersChanged();
    void isLoadingChanged();
    void error(const QString& message);
    void success(const QString& message);

private:
    PcService m_service;
    QVariantList m_computers;
    QMap<quint64, QString> m_departmentNames;

private slots:
    void handleComputersLoaded(const QVector<PcDto>& computers);
    void handleComputerAdded(const PcDto& computer);
    void handleComputerDeleted(quint64 id);
    void handleError(const QString& message);
};