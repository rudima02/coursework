#pragma once
#include "../tables/dto/departmentDTO.h"
#include <../include/httplib.h>
#include <vector>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

inline void setupDepartmentRoutes(httplib::Server& server) {
    static std::vector<DepartmentDTO> departments;

    server.Get("/departments", [](const httplib::Request&, httplib::Response& res) {
        json j = departments;
        res.set_content(j.dump(), "application/json");
    });

    server.Post("/departments", [](const httplib::Request& req, httplib::Response& res) {
        auto j = json::parse(req.body);
        DepartmentDTO d = j.get<DepartmentDTO>();
        d.id = departments.size() + 1;
        departments.push_back(d);

        res.set_content(json(d).dump(), "application/json");
    });
}
