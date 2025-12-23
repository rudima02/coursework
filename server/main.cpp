#include <iostream>
#include "../include/db.hpp"
#include "routes/category_routes.h"
#include "routes/department_routes.h"
#include "routes/pc_routes.h"
#include "routes/po_routes.h"
#include "routes/semi_routes.h"
#include "routes/users_routes.h"
#include "routes/versionpo_routes.h"
#include "routes/roles_routes.h"
#include "routes/report_routes.h"
#include "include/httplib.h"


int main() {
    try {
        auto db = createDBFromEnv();
        
        httplib::Server server;
        registerReportRoutes(server, db);
        registerCategoryRoutes(server, db);
        registerDepartmentRoutes(server, db);
        registerPCRoutes(server, db);
        registerPORoutes(server, db);
        registerRolesRoutes(server, db);
        registerSemiRoutes(server, db);
        registerUsersRoutes(server, db);
        registerVersionPORoutes(server, db);
        
        server.listen("0.0.0.0", 8081);
    } catch (const std::exception& ex) {
        std::cerr << "Exception: " << ex.what() << std::endl;
        return 1;
    }
    return 0;
}