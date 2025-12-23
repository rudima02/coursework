#pragma once
#include <QObject>
#include <QVector>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include "../network/ApiClient.h"
#include "../dto/CategoryDto.h"

class CategoryService : public QObject {
    Q_OBJECT
public:
    explicit CategoryService(QObject* parent = nullptr);
    
    void loadCategories();
    void addCategory(const QString& name);
    void deleteCategory(quint64 id);
    bool isLoading() const { return m_api.isLoading(); }
    
signals:
    void categoriesLoaded(const QVector<CategoryDto>& categories);
    void categoryAdded(const CategoryDto& category);
    void categoryDeleted(quint64 id);
    void error(const QString& message);

private:
    ApiClient m_api;

private slots:
    void handleGetSuccess(const QByteArray& data, const QString& endpoint);
    void handlePostSuccess(const QByteArray& data, const QString& endpoint);
    void handleError(const QString& error, const QString& endpoint);
};