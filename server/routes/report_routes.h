#pragma once
#include <httplib.h>
#include <odb/pgsql/database.hxx>
#include <memory>

void registerReportRoutes( httplib::Server& server, std::shared_ptr<odb::pgsql::database> db);
