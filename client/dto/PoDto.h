#pragma once
#include <QString>
#include <QVector>
#include <QJsonObject>
#include <QJsonArray>
#include "VersionPoDto.h"

struct PoDto {
    quint64 id = 0;
    QString name;
    quint64 categoryId = 0;
    QVector<VersionPoDto> versions;

    static PoDto fromJson(const QJsonObject& obj) {
        PoDto p;
        p.id = obj["id"].toVariant().toULongLong();
        p.name = obj["name"].toString();
        p.categoryId = obj["category_id"].toVariant().toULongLong();

        if (obj.contains("versions")) {
            auto arr = obj["versions"].toArray();
            for (const auto& v : arr) {
                p.versions.push_back(VersionPoDto::fromJson(v.toObject()));
            }
        }

        return p;
    }

    QJsonObject toJson() const {
        QJsonObject obj;
        obj["name"] = name;
        obj["category_id"] = QString::number(categoryId);
        return obj;
    }
};