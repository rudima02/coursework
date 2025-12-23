#pragma once
#include <QString>
#include <QVector>
#include <QJsonObject>
#include <QJsonArray>
#include "PoDto.h"

struct CategoryDto {
    quint64 id = 0;
    QString name;
    QVector<PoDto> programs;

    static CategoryDto fromJson(const QJsonObject& obj) {
        CategoryDto c;
        c.id = obj["id"].toVariant().toULongLong();
        c.name = obj["name"].toString();

        if (obj.contains("programs")) {
            auto arr = obj["programs"].toArray();
            for (const auto& v : arr) {
                c.programs.push_back(PoDto::fromJson(v.toObject()));
            }
        }

        return c;
    }

    QJsonObject toJson() const {
        QJsonObject obj;
        obj["name"] = name;
        return obj;
    }
};