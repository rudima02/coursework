#pragma once
#include <QString>
#include <QJsonObject>

struct VersionPoDto {
    quint64 id = 0;
    QString version;
    QString dateVersion;
    quint64 poId = 0;

    static VersionPoDto fromJson(const QJsonObject& obj) {
        VersionPoDto v;
        v.id = obj["id"].toVariant().toULongLong();
        v.version = obj["version"].toString();
        v.dateVersion = obj["date_version"].toString();
        v.poId = obj["po_id"].toVariant().toULongLong();
        return v;
    }

    QJsonObject toJson() const {
        QJsonObject obj;
        obj["version"] = version;
        obj["date_version"] = dateVersion;
        obj["po_id"] = QString::number(poId);
        return obj;
    }
};