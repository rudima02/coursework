#pragma once
#include <memory>
#include <string>
#include <cstdlib>
#include <odb/pgsql/database.hxx>

inline std::shared_ptr<odb::pgsql::database> createDBFromEnv() {
    const char* host = std::getenv("DB_HOST");
    const char* port = std::getenv("DB_PORT");
    const char* user = std::getenv("DB_USER");
    const char* pass = std::getenv("DB_PASSWORD");
    const char* name = std::getenv("DB_NAME");

    std::string host_str = host ? host : "localhost";
    std::string port_str = port ? port : "5432";
    std::string user_str = user ? user : "rudima02";
    std::string pass_str = pass ? pass : "QwE21gg9";
    std::string name_str = name ? name : "coursework";

    return std::make_shared<odb::pgsql::database>(
        user_str, pass_str, name_str, host_str, port_str
    );
}
