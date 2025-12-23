#pragma once
#include <QObject>
#include <QVariantList>
#include "../services/CategoryService.h"

class CategoryViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList categories READ categories NOTIFY categoriesChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit CategoryViewModel(QObject* parent = nullptr);

    Q_INVOKABLE void load();
    Q_INVOKABLE void addCategory(const QString& name);
    Q_INVOKABLE void deleteCategory(quint64 id);
    
    QVariantList categories() const { return m_categories; }
    bool isLoading() const { return m_service.isLoading(); }

signals:
    void categoriesChanged();
    void isLoadingChanged();
    void error(const QString& message);
    void success(const QString& message);

private:
    CategoryService m_service;
    QVariantList m_categories;

private slots:
    void handleCategoriesLoaded(const QVector<CategoryDto>& categories);
    void handleCategoryAdded(const CategoryDto& category);
    void handleCategoryDeleted(quint64 id);
};