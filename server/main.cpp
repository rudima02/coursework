#include "server.hpp"
#include "routes/category_routes.h"
#include "routes/po_routes.h"
#include "routes/department_route.h"
#include "routes/pc_routes.h"
#include "routes/roles_route.h"
#include "routes/user_route.h"

int main() {
    auto& app = Server::instance();

    setupCategoryRoutes(app);
    setupDepartmentRoutes(app);
    setupPCRoutes(app);
    setupPORoutes(app);
    setupRolesRoutes(app);
    setupUsersRoutes(app);

    printf("Server running http://localhost:8080\n");
    app.listen("0.0.0.0", 8080);
}
