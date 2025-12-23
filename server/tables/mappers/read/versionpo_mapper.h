#pragma once
#include "../tables/all_tables_single.h"
#include "../tables/dto/versionPODTO.h"

inline VersionPODTO toDTO(const VersionPO& v) {
    VersionPODTO dto;
    dto.id = v.getID();
    dto.version = v.getVersion();
    dto.date_version = v.getDate();
    if (v.getPO())
        dto.po_id = v.getPO()->getID(); 
    return dto;
}
