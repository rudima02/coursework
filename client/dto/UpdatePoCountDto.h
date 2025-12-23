#pragma once
#include <QString>

struct UpdatePoCountDto {
    quint64 poId;
    QString poName;
    
    UpdatePoCountDto() : poId(0) {}
    UpdatePoCountDto(quint64 id, const QString& name) : poId(id), poName(name) {}
};
