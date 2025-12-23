#include "report_routes.h"
#include "../tables/orm/all_tables_single-odb.hxx"
#include <nlohmann/json.hpp>
#include <odb/transaction.hxx>

using json = nlohmann::json;

void registerReportRoutes(httplib::Server& server,
                          std::shared_ptr<odb::pgsql::database> db) {

    // ===== GET /reports =====
    server.Get("/reports", [db](const httplib::Request&, httplib::Response& res) {
        try {
            odb::transaction t(db->begin());

            json report;
            json departmentsJson = json::array();

            for (const Department& dept : db->query<Department>()) {
                json deptJson;
                deptJson["id"] = dept.getID();
                deptJson["name"] = dept.getName();

                // PCs
                json pcsJson = json::array();
                for (const PC& pc :
                     db->query<PC>(odb::query<PC>::department->id == dept.getID())) {

                    json pcJson;
                    pcJson["id"] = pc.getID();
                    pcJson["name"] = pc.getName();

                    json softwareJson = json::array();
                    for (const Semi& s :
                         db->query<Semi>(odb::query<Semi>::pc->id == pc.getID())) {
                        auto po = s.getPO();
                        softwareJson.push_back({
                            {"id", po->getID()},
                            {"name", po->getName()}
                        });
                    }

                    pcJson["installed_software"] = softwareJson;
                    pcsJson.push_back(pcJson);
                }

                deptJson["pcs"] = pcsJson;

                // Users
                json usersJson = json::array();
                for (const Users& u :
                     db->query<Users>(odb::query<Users>::department->id == dept.getID())) {
                    usersJson.push_back({
                        {"id", u.getID()},
                        {"name", u.getName()},
                        {"role", u.getRole()->getName()}
                    });
                }

                deptJson["users"] = usersJson;
                departmentsJson.push_back(deptJson);
            }

            report["departments"] = departmentsJson;
            report["summary"] = {
                {"total_departments", departmentsJson.size()},
                {"total_pcs", db->query<PC>().size()},
                {"total_software", db->query<PO>().size()},
                {"total_users", db->query<Users>().size()}
            };

            t.commit();
            res.set_content(report.dump(2), "application/json");
        } catch (...) {
            res.status = 500;
        }
    });

    // ===== POST /admin/bulkAddPc =====
    server.Post("/admin/bulkAddPc", [db](const httplib::Request& req, httplib::Response& res) {
        try {
            json j = json::parse(req.body);

            auto departmentIds = j["departmentIds"].get<std::vector<unsigned long>>();
            int pcsPerDepartment = j["pcsPerDepartment"];
            unsigned long poId = j["poId"];

            odb::transaction t(db->begin());

            auto po = db->load<PO>(poId);
            std::shared_ptr<PO> poPtr(po);

            for (auto deptId : departmentIds) {
                auto dept = db->load<Department>(deptId);
                std::shared_ptr<Department> deptPtr(dept);

                for (int i = 0; i < pcsPerDepartment; ++i) {
                    auto pc = std::make_shared<PC>(
                        "ПК #" + std::to_string(i + 1),
                        deptPtr
                    );
                    db->persist(*pc);

                    auto semi = std::make_shared<Semi>(poPtr, pc);
                    db->persist(*semi);
                }
            }

            t.commit();
            res.status = 201;
            res.set_content(R"({"success":true})", "application/json");
        } catch (...) {
            res.status = 500;
        }
    });
}
