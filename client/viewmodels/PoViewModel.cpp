#include "PoViewModel.h"
#include "CategoryViewModel.h"
#include <QDebug>

PoViewModel::PoViewModel(QObject* parent)
    : QObject(parent)
{
    connect(&m_service, &PoService::programsLoaded,
            this, &PoViewModel::handleProgramsLoaded);
    connect(&m_service, &PoService::programAdded,
            this, &PoViewModel::handleProgramAdded);
    connect(&m_service, &PoService::programDeleted,
            this, &PoViewModel::handleProgramDeleted);
    connect(&m_service, &PoService::error,
            this, &PoViewModel::handleError);
}

void PoViewModel::load() {
    m_service.loadPrograms();
}

void PoViewModel::addProgram(const QString& name, quint64 categoryId) {
    m_service.addProgram(name, categoryId);
}

void PoViewModel::deleteProgram(quint64 id) {
    m_service.deleteProgram(id);
}

QString PoViewModel::getCategoryName(quint64 categoryId) const {
    return m_categoryNames.value(categoryId, QString("Категория ID:%1").arg(categoryId));
}

void PoViewModel::updateCategoryCache() {
}

void PoViewModel::handleProgramsLoaded(const QVector<PoDto>& programs) {
    m_programs.clear();
    
    for (const auto& program : programs) {
        QVariantMap progMap;
        progMap["id"] = QVariant::fromValue(program.id);
        progMap["name"] = program.name;
        progMap["categoryId"] = QVariant::fromValue(program.categoryId);
        progMap["categoryName"] = getCategoryName(program.categoryId);
        
        if (!m_categoryNames.contains(program.categoryId)) {
            m_categoryNames[program.categoryId] = QString("Категория ID:%1").arg(program.categoryId);
        }
        
        QVariantList versions;
        for (const auto& version : program.versions) {
            QVariantMap verMap;
            verMap["id"] = QVariant::fromValue(version.id);
            verMap["version"] = version.version;
            verMap["dateVersion"] = version.dateVersion;
            verMap["poId"] = QVariant::fromValue(version.poId);
            //TODO актуальная версия в бдшке
            //verMap["isActual"] = version.isActual;
            versions.append(verMap);
        }
        progMap["versions"] = versions;
        
        m_programs.append(progMap);
    }
    
    emit programsChanged();
    emit success("Программы загружены");
}

void PoViewModel::handleProgramAdded(const PoDto& program) {
    Q_UNUSED(program)
    load();
    emit success("Программа добавлена");
}

void PoViewModel::handleProgramDeleted(quint64 id) {
    Q_UNUSED(id)
    load();
    emit success("Программа удалена");
}

void PoViewModel::handleError(const QString& message) {
    emit error(message);
}