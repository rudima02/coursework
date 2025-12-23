#include "CategoryService.h"

CategoryService::CategoryService(QObject* parent)
    : QObject(parent)
{
    connect(&m_api, &ApiClient::requestSuccess, this, &CategoryService::handleGetSuccess);
    connect(&m_api, &ApiClient::requestError, this, &CategoryService::handleError);
}

void CategoryService::loadCategories() {
    m_api.get("/categories");
}

void CategoryService::addCategory(const QString& name) {
    QJsonObject data;
    data["name"] = name;
    
    m_api.post("/categories", data);
    connect(&m_api, &ApiClient::requestSuccess, this, &CategoryService::handlePostSuccess, Qt::UniqueConnection);

}

void CategoryService::deleteCategory(quint64 id) {
    QString endpoint = "/categories/" + QString::number(id);
    m_api.deleteResource(endpoint);
}

void CategoryService::handleGetSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/categories") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonArray arr = doc.array();
        
        QVector<CategoryDto> categories;
        for (const auto& v : arr) {
            categories.append(CategoryDto::fromJson(v.toObject()));
        }
        
        emit categoriesLoaded(categories);
    }
}

void CategoryService::handlePostSuccess(const QByteArray& data, const QString& endpoint) {
    if (endpoint == "/categories") {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        CategoryDto category = CategoryDto::fromJson(doc.object());
        emit categoryAdded(category);
    }
}

void CategoryService::handleError(const QString& errorMsg, const QString& endpoint) {
    Q_UNUSED(endpoint)
    emit error(errorMsg);
}