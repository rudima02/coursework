#pragma once
#include <string>
#include <vector>
#include <memory>
#include "odb/core.hxx"
#include "department.h"
#include "semi.h"

class Department;
class Semi;

#pragma db object
class PC{
private:
    friend class odb::access;

#pragma db id auto
    unsigned long id;

    std::string name_pc;

#pragma db not_null
#pragma db column("id_department")
    std::shared_ptr<Department> department;

#pragma db inverse(pc)
    std::vector<std::shared_ptr<Semi>> semis;

public:
    PC()= default;
    PC(const std::string& name_pc, const std::shared_ptr<Department>& department) : name_pc(name_pc), department(department){}

    unsigned getID() const{
        return id;
    }

    const std::string& getName() const{
        return name_pc;
    }

    const std::shared_ptr<Department>& getDepartment() const{
        return department;
    }

    const std::vector<std::shared_ptr<Semi>>& getSemis() const{
        return semis;
    }

    void setName(const std::string& name){
        name_pc = name;
    }

    void setDepartment(const std::shared_ptr<Department>& depart){
        department = depart;
    }


    void setSemi(const std::shared_ptr<Semi>& semi){
        semis.emplace_back(semi);
    }
};
