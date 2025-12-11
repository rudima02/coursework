#include <iostream>
#include <memory>
#include <odb/pgsql/database.hxx>
#include <odb/transaction.hxx>
#include "tables/category-odb.hxx"
#include "tables/department-odb.hxx"
#include "tables/pc-odb.hxx"
#include "tables/po-odb.hxx"
#include "tables/roles-odb.hxx"
#include "tables/semi-odb.hxx"
#include "tables/users-odb.hxx"
#include "tables/version_po-odb.hxx"

using namespace std;

int main() {
    try {
        auto db = make_shared<odb::pgsql::database>("rudima02", "QwE21gg9", "coursework", "localhost", 5432);

        odb::transaction t(db->begin());

        Category cat1("Category 1");
        Category cat2("Category 2");
        db->persist(cat1);
        db->persist(cat2);

        Department dept("IT Department");
        db->persist(dept);

        Roles role("Admin");
        db->persist(role);

        Users user("Dmitriy", make_shared<Department>(dept), make_shared<Roles>(role));
        db->persist(user);

        PO po("Program 1", make_shared<Category>(cat1));
        db->persist(po);

        VersionPO ver_po("v1.0", "2025-12-11", false, make_shared<PO>(po));
        db->persist(ver_po);

        PC pc("PC 1", make_shared<Department>(dept));
        db->persist(pc);

        Semi semi(make_shared<PO>(po), make_shared<PC>(pc));
        db->persist(semi);

        t.commit();

        cout << "Данные успешно добавлены!" << endl;
    }
    catch (const odb::exception& e) {
        cerr << e.what() << endl;
        return 1;
    }
    return 0;
}
