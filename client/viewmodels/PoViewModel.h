#pragma once
#include <QObject>
#include <QVariantList>
#include "../services/PoService.h"

class PoViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList programs READ programs NOTIFY programsChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit PoViewModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void addProgram(const QString& name, quint64 categoryId);
    Q_INVOKABLE void deleteProgram(quint64 id);
    
    QVariantList programs() const { return m_programs; }
    bool isLoading() const { return m_service.isLoading(); }
    
    Q_INVOKABLE QString getCategoryName(quint64 categoryId) const;

signals:
    void programsChanged();
    void isLoadingChanged();
    void error(const QString& message);
    void success(const QString& message);

private:
    PoService m_service;
    QVariantList m_programs;
    
    QMap<quint64, QString> m_categoryNames;

private slots:
    void handleProgramsLoaded(const QVector<PoDto>& programs);
    void handleProgramAdded(const PoDto& program);
    void handleProgramDeleted(quint64 id);
    void handleError(const QString& message);
    void updateCategoryCache();
};