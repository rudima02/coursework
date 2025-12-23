#pragma once
#include <QString>
#include <QVector>
#include <QJsonObject>
#include <QJsonArray>

struct PcDto {
    quint64 id = 0;
    QString name;
    quint64 departmentId = 0;
    QVector<quint64> installedPoIds;

    static PcDto fromJson(const QJsonObject& obj) {
        PcDto p;
        p.id = obj["id"].toVariant().toULongLong();
        p.name = obj["name"].toString();
        p.departmentId = obj["department_id"].toVariant().toULongLong();

        if (obj.contains("installed_po_ids")) {
            auto arr = obj["installed_po_ids"].toArray();
            for (const auto& v : arr) {
                p.installedPoIds.push_back(v.toVariant().toULongLong());
            }
        }

        return p;
    }

    QJsonObject toJson() const {
        QJsonObject obj;
        obj["name"] = name;
        obj["department_id"] = QString::number(departmentId);
        return obj;
    }
};