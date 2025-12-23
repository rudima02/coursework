#pragma once
#include <QJsonObject>

struct SemiDto {
    quint64 id = 0;
    quint64 poId;
    quint64 pcId;

    static SemiDto fromJson(const QJsonObject& obj) {
        SemiDto s;
        s.id = obj["id"].toVariant().toULongLong();
        s.poId = obj["po_id"].toVariant().toULongLong();
        s.pcId = obj["pc_id"].toVariant().toULongLong();
        return s;
    }

    QJsonObject toJson() const {
        QJsonObject obj;
        obj["po_id"] = QString::number(poId);
        obj["pc_id"] = QString::number(pcId);
        return obj;
    }
};