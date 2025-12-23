#include "PcViewModel.h"
#include <QDebug>

PcViewModel::PcViewModel(QObject* parent)
    : QObject(parent)
{
    connect(&m_service, &PcService::computersLoaded,
            this, &PcViewModel::handleComputersLoaded);
    connect(&m_service, &PcService::computerAdded,
            this, &PcViewModel::handleComputerAdded);
    connect(&m_service, &PcService::computerDeleted,
            this, &PcViewModel::handleComputerDeleted);
    connect(&m_service, &PcService::error,
            this, &PcViewModel::handleError);
}

void PcViewModel::load() {
    m_service.loadComputers();
}

void PcViewModel::addComputer(const QString& name, quint64 departmentId) {
    m_service.addComputer(name, departmentId);
}

void PcViewModel::deleteComputer(quint64 id) {
    m_service.deleteComputer(id);
}

QString PcViewModel::getDepartmentName(quint64 departmentId) const {
    return m_departmentNames.value(departmentId, QString("Отдел ID:%1").arg(departmentId));
}

QString PcViewModel::getComputerDisplayName(quint64 computerId) const {
    for (const auto& computer : m_computers) {
        if (computer.toMap()["id"].toULongLong() == computerId) {
            return computer.toMap()["name"].toString() + " (PC-" + QString::number(computerId) + ")";
        }
    }
    return QString("Компьютер ID:%1").arg(computerId);
}

void PcViewModel::handleComputersLoaded(const QVector<PcDto>& computers) {
    m_computers.clear();
    
    for (const auto& computer : computers) {
        QVariantMap compMap;
        compMap["id"] = QVariant::fromValue(computer.id);
        compMap["name"] = computer.name;
        compMap["departmentId"] = QVariant::fromValue(computer.departmentId);
        compMap["departmentName"] = getDepartmentName(computer.departmentId);
        
        if (!m_departmentNames.contains(computer.departmentId)) {
            m_departmentNames[computer.departmentId] = QString("Отдел ID:%1").arg(computer.departmentId);
        }
        
        QVariantList installedPoIds;
        for (const auto& poId : computer.installedPoIds) {
            installedPoIds.append(QVariant::fromValue(poId));
        }
        compMap["installedPoIds"] = installedPoIds;
        
        m_computers.append(compMap);
    }
    
    emit computersChanged();
    emit success("Компьютеры загружены");
}

void PcViewModel::handleComputerAdded(const PcDto& computer) {
    Q_UNUSED(computer)
    load();
    emit success("Компьютер добавлен");
}

void PcViewModel::handleComputerDeleted(quint64 id) {
    Q_UNUSED(id)
    load();
    emit success("Компьютер удален");
}

void PcViewModel::handleError(const QString& message) {
    emit error(message);
}