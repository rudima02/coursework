#pragma once
#include "../tables/dto/categoryDTO.h"
#include <httplib.h>
#include <vector>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

inline void setupCategoryRoutes(httplib::Server& server) {
    static std::vector<CategoryDTO> categories;

    server.Get("/categories", [](const httplib::Request&, httplib::Response& res) {
        json j = categories;
        res.set_content(j.dump(), "application/json");
    });

    server.Post("/categories", [](const httplib::Request& req, httplib::Response& res) {
        auto j = json::parse(req.body);
        CategoryDTO c = j.get<CategoryDTO>();
        c.id = categories.size() + 1;
        categories.push_back(c);

        res.set_content(json(c).dump(), "application/json");
    });
}
