#include "AdminViewModel.h"
#include <QDebug>

AdminViewModel::AdminViewModel(QObject* parent)
    : QObject(parent)
    , m_isLoading(false)
{
    connect(&m_service, &AdminService::success, this, [this](){
        m_isLoading = false;
        emit isLoadingChanged();
        emit success("ПК успешно добавлены");
        qDebug() << "ПК успешно добавлены";
    });

    connect(&m_service, &AdminService::error, this, [this](const QString& msg){
        m_isLoading = false;
        emit isLoadingChanged();
        emit error(msg);
        qDebug() << "Ошибка при добавлении ПК:" << msg;
    });
}

void AdminViewModel::bulkAdd(const QVariantList& departmentIds, int pcsPerDepartment, int poId) {
    if (departmentIds.isEmpty()) {
        emit error("Не выбраны отделы");
        return;
    }
    if (pcsPerDepartment <= 0) {
        emit error("Количество ПК должно быть больше 0");
        return;
    }
    if (poId <= 0) {
        emit error("Некорректное ПО");
        return;
    }

    m_isLoading = true;
    emit isLoadingChanged();
    
    qDebug() << "Добавление ПК: отделы:" << departmentIds 
             << ", количество:" << pcsPerDepartment 
             << ", ПО ID:" << poId;

    m_service.bulkAdd(departmentIds, pcsPerDepartment, poId);
}