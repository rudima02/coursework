#pragma once
#include "../tables/dto/poDTO.h"
#include <httplib.h>
#include <vector>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

inline void setupPORoutes(httplib::Server& server) {
    static std::vector<PODTO> softwares;

    server.Get("/software", [](const httplib::Request&, httplib::Response& res) {
        json j = softwares;
        res.set_content(j.dump(), "application/json");
    });

    server.Post("/software", [](const httplib::Request& req, httplib::Response& res) {
        auto j = json::parse(req.body);
        PODTO p = j.get<PODTO>();
        p.id = softwares.size() + 1;
        softwares.push_back(p);

        res.set_content(json(p).dump(), "application/json");
    });
}
