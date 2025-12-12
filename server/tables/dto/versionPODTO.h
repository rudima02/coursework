#pragma once
#include <string>
#include <nlohmann/json.hpp>

class VersionPODTO {
public:
    unsigned long id = 0;
    std::string version;
    std::string date_version;
    bool downloaded = false;

    VersionPODTO() = default;
};

inline void to_json(nlohmann::json& j, const VersionPODTO& v) {
    j = {
        {"id", v.id},
        {"version", v.version},
        {"date_version", v.date_version},
        {"downloaded", v.downloaded}
    };
}

inline void from_json(const nlohmann::json& j, VersionPODTO& v) {
    if (j.contains("id")) j.at("id").get_to(v.id);
    j.at("version").get_to(v.version);
    j.at("date_version").get_to(v.date_version);
    j.at("downloaded").get_to(v.downloaded);
}
