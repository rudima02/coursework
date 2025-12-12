#pragma once
#include <string>
#include <vector>
#include <nlohmann/json.hpp>

class RolesDTO {
public:
    unsigned long id = 0;
    std::string name_role;
    std::vector<unsigned long> user_ids;

    RolesDTO() = default;
};

inline void to_json(nlohmann::json& j, const RolesDTO& r) {
    j = { {"id", r.id}, {"name_role", r.name_role}, {"user_ids", r.user_ids} };
}

inline void from_json(const nlohmann::json& j, RolesDTO& r) {
    if (j.contains("id")) j.at("id").get_to(r.id);
    j.at("name_role").get_to(r.name_role);
    if (j.contains("user_ids")) j.at("user_ids").get_to(r.user_ids);
}
