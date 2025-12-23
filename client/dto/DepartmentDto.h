#pragma once
#include <QString>
#include <QVector>
#include <QJsonObject>
#include <QJsonArray>
#include "PcDto.h"

struct DepartmentDto {
    quint64 id = 0;
    QString name;
    QVector<PcDto> pcs;
    QVector<quint64> users;

    static DepartmentDto fromJson(const QJsonObject& obj) {
        DepartmentDto dto;
        dto.id = obj["id"].toVariant().toULongLong();
        dto.name = obj["name"].toString();

        if (obj.contains("pcs")) {
            auto arr = obj["pcs"].toArray();
            for (const auto& v : arr) {
                dto.pcs.push_back(PcDto::fromJson(v.toObject()));
            }
        }

        if (obj.contains("users")) {
            auto arr = obj["users"].toArray();
            for (const auto& v : arr) {
                dto.users.push_back(v.toVariant().toULongLong());
            }
        }

        return dto;
    }

    QJsonObject toJson() const {
        QJsonObject obj;
        obj["name"] = name;
        return obj;
    }
};