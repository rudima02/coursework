#pragma once
#include <string>
#include <vector>
#include <nlohmann/json.hpp>

class DepartmentDTO {
public:
    unsigned long id = 0;
    std::string name_department;
    std::vector<unsigned long> pc_ids;
    std::vector<unsigned long> user_ids;

    DepartmentDTO() = default;
};

inline void to_json(nlohmann::json& j, const DepartmentDTO& d) {
    j = {
        {"id", d.id},
        {"name_department", d.name_department},
        {"pc_ids", d.pc_ids},
        {"user_ids", d.user_ids}
    };
}

inline void from_json(const nlohmann::json& j, DepartmentDTO& d) {
    if (j.contains("id")) j.at("id").get_to(d.id);
    j.at("name_department").get_to(d.name_department);
    if (j.contains("pc_ids")) j.at("pc_ids").get_to(d.pc_ids);
    if (j.contains("user_ids")) j.at("user_ids").get_to(d.user_ids);
}
