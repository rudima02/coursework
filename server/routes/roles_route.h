#pragma once
#include "../tables/dto/rolesDTO.h"
#include <httplib.h>
#include <vector>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

inline void setupRolesRoutes(httplib::Server& server) {
    static std::vector<RolesDTO> roles;

    server.Get("/roles", [](const httplib::Request&, httplib::Response& res) {
        json j = roles;
        res.set_content(j.dump(), "application/json");
    });

    server.Post("/roles", [](const httplib::Request& req, httplib::Response& res) {
        auto j = json::parse(req.body);
        RolesDTO r = j.get<RolesDTO>();
        r.id = roles.size() + 1;
        roles.push_back(r);

        res.set_content(json(r).dump(), "application/json");
    });
}
