#include "CategoryViewModel.h"

CategoryViewModel::CategoryViewModel(QObject* parent)
    : QObject(parent)
{
    connect(&m_service, &CategoryService::categoriesLoaded,
            this, &CategoryViewModel::handleCategoriesLoaded);
    connect(&m_service, &CategoryService::categoryAdded,
            this, &CategoryViewModel::handleCategoryAdded);
    connect(&m_service, &CategoryService::categoryDeleted,
            this, &CategoryViewModel::handleCategoryDeleted);
    connect(&m_service, &CategoryService::error,
            this, &CategoryViewModel::error);
}

void CategoryViewModel::load() {
    m_service.loadCategories();
}

void CategoryViewModel::addCategory(const QString& name) {
    m_service.addCategory(name);
}

void CategoryViewModel::deleteCategory(quint64 id) {
    m_service.deleteCategory(id);
}

void CategoryViewModel::handleCategoriesLoaded(const QVector<CategoryDto>& categories) {
    m_categories.clear();
    
    for (const auto& category : categories) {
        QVariantMap catMap;
        catMap["id"] = QVariant::fromValue(category.id);
        catMap["name"] = category.name;
        
        QVariantList programs;
        for (const auto& program : category.programs) {
            QVariantMap progMap;
            progMap["id"] = QVariant::fromValue(program.id);
            progMap["name"] = program.name;
            progMap["categoryId"] = QVariant::fromValue(program.categoryId);
            programs.append(progMap);
        }
        catMap["programs"] = programs;
        
        m_categories.append(catMap);
    }
    
    emit categoriesChanged();
    emit success("Категории загружены");
}

void CategoryViewModel::handleCategoryAdded(const CategoryDto& category) {
    load(); // Перезагружаем список
    emit success("Категория добавлена");
}

void CategoryViewModel::handleCategoryDeleted(quint64 id) {
    load(); // Перезагружаем список
    emit success("Категория удалена");
}