#pragma once
#include "../tables/dto/usersDTO.h"
#include <httplib.h>
#include <vector>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

inline void setupUsersRoutes(httplib::Server& server) {
    static std::vector<UsersDTO> users;

    server.Get("/users", [](const httplib::Request&, httplib::Response& res) {
        json j = users;
        res.set_content(j.dump(), "application/json");
    });

    server.Post("/users", [](const httplib::Request& req, httplib::Response& res) {
        auto j = json::parse(req.body);
        UsersDTO u = j.get<UsersDTO>();
        u.id = users.size() + 1;
        users.push_back(u);

        res.set_content(json(u).dump(), "application/json");
    });
}
