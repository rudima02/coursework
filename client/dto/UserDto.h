#pragma once
#include <QString>
#include <QVector>
#include <QJsonObject>
#include <QJsonArray>

struct UserDto {
    quint64 id = 0;
    QString name;
    quint64 departmentId = 0;
    quint64 roleId = 0;
    QVector<quint64> pcIds;
    QVector<quint64> installedPoIds;

    static UserDto fromJson(const QJsonObject& obj) {
        UserDto u;
        u.id = obj["id"].toVariant().toULongLong();
        u.name = obj["name"].toString();
        u.departmentId = obj["department_id"].toVariant().toULongLong();
        u.roleId = obj["role_id"].toVariant().toULongLong();

        if (obj.contains("pc_ids")) {
            auto arr = obj["pc_ids"].toArray();
            for (const auto& v : arr) {
                u.pcIds.push_back(v.toVariant().toULongLong());
            }
        }

        if (obj.contains("installed_po_ids")) {
            auto arr = obj["installed_po_ids"].toArray();
            for (const auto& v : arr) {
                u.installedPoIds.push_back(v.toVariant().toULongLong());
            }
        }

        return u;
    }

    QJsonObject toJson() const {
        QJsonObject obj;
        obj["name"] = name;
        obj["department_id"] = QString::number(departmentId);
        obj["role_id"] = QString::number(roleId);
        return obj;
    }
};