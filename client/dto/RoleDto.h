#pragma once
#include <QString>
#include <QVector>
#include <QJsonObject>
#include <QJsonArray>

struct RoleDto {
    quint64 id = 0;
    QString name;
    QVector<quint64> userIds;

    static RoleDto fromJson(const QJsonObject& obj) {
        RoleDto r;
        r.id = obj["id"].toVariant().toULongLong();
        r.name = obj["name"].toString();

        if (obj.contains("user_ids")) {
            auto arr = obj["user_ids"].toArray();
            for (const auto& v : arr) {
                r.userIds.push_back(v.toVariant().toULongLong());
            }
        }

        return r;
    }

    QJsonObject toJson() const {
        QJsonObject obj;
        obj["name"] = name;
        return obj;
    }
};