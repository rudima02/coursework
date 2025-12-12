#pragma once
#include "../tables/dto/pcDTO.h"
#include <httplib.h>
#include <vector>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

inline void setupPCRoutes(httplib::Server& server) {
    static std::vector<PCDTO> pcs;

    server.Get("/pcs", [](const httplib::Request&, httplib::Response& res) {
        json j = pcs;
        res.set_content(j.dump(), "application/json");
    });

    server.Post("/pcs", [](const httplib::Request& req, httplib::Response& res) {
        auto j = json::parse(req.body);
        PCDTO p = j.get<PCDTO>();
        p.id = pcs.size() + 1;
        pcs.push_back(p);

        res.set_content(json(p).dump(), "application/json");
    });
}
