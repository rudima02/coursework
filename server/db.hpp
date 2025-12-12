#pragma once
#include <memory>
#include <odb/database.hxx>
#include <odb/pgsql/database.hxx>
#include <odb/transaction.hxx>

class DB {
public:
    static std::shared_ptr<odb::pgsql::database> get() {
        static std::shared_ptr<odb::pgsql::database> db =
            std::make_shared<odb::pgsql::database>(
                "rudima02",  // user
                "QwE21gg9",      // password
                "coursework" // database
            );
        return db;
    }
};
