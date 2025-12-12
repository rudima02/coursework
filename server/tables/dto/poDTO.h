#pragma once
#include <string>
#include <vector>
#include "versionPODTO.h"
#include <nlohmann/json.hpp>

class PODTO {
public:
    unsigned long id = 0;
    std::string name_po;
    unsigned long category_id = 0;
    std::vector<VersionPODTO> versions;

    PODTO() = default;
};

inline void to_json(nlohmann::json& j, const PODTO& p) {
    j = {
        {"id", p.id},
        {"name_po", p.name_po},
        {"category_id", p.category_id},
        {"versions", p.versions}
    };
}

inline void from_json(const nlohmann::json& j, PODTO& p) {
    if (j.contains("id")) j.at("id").get_to(p.id);
    j.at("name_po").get_to(p.name_po);
    if (j.contains("category_id")) j.at("category_id").get_to(p.category_id);
    if (j.contains("versions")) j.at("versions").get_to(p.versions);
}
