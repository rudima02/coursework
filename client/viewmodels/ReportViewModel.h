#pragma once
#include <QObject>
#include <QVariantList>
#include "../services/ReportService.h"

class ReportViewModel : public QObject {
    Q_OBJECT

    Q_PROPERTY(QVariantList departments READ departments NOTIFY departmentsChanged)

    Q_PROPERTY(int totalPc READ totalPc NOTIFY summaryChanged)
    Q_PROPERTY(int totalPo READ totalPo NOTIFY summaryChanged)
    Q_PROPERTY(int totalUsers READ totalUsers NOTIFY summaryChanged)

    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit ReportViewModel(QObject* parent = nullptr);

    QVariantList departments() const { return m_departments; }

    int totalPc() const { return m_totalPc; }
    int totalPo() const { return m_totalPo; }
    int totalUsers() const { return m_totalUsers; }

    bool isLoading() const { return m_isLoading; }

    Q_INVOKABLE void load();

signals:
    void departmentsChanged();
    void summaryChanged();
    void isLoadingChanged();
    void error(const QString& msg);
    void success(const QString& msg);

private:
    void parse(const QByteArray& data);

    QVariantList m_departments;

    int m_totalPc{0};
    int m_totalPo{0};
    int m_totalUsers{0};

    bool m_isLoading{false};

    ReportService m_service;
};
