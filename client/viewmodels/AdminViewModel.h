#pragma once
#include <QObject>
#include "../services/AdminService.h"

class AdminViewModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)
    
public:
    explicit AdminViewModel(QObject *parent = nullptr);
    
    bool isLoading() const { return m_isLoading; }
    
    Q_INVOKABLE void bulkAdd(const QVariantList& departmentIds, int pcsPerDepartment, int poId);
    
signals:
    void isLoadingChanged();
    void success(const QString& message);
    void error(const QString& message);
    
private:
    AdminService m_service;
    bool m_isLoading;
};
