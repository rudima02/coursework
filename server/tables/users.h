#pragma once
#include <string>
#include <memory>
#include "odb/core.hxx"
#include "department.h"
#include "roles.h"

class Department;
class Roles;

#pragma db object
class Users{
private:
    friend class odb::access;

#pragma db id auto
    unsigned long id;

    std::string name_user;

#pragma db not_null
#pragma db column("id_department")
    std::shared_ptr<Department> department;

#pragma db not_null
#pragma db column("id_roles")
    std::shared_ptr<Roles> roles;

public:
    Users()= default;
    Users(const std::string& name_user, const std::shared_ptr<Department>& department, const std::shared_ptr<Roles>& roles) :  name_user(name_user), department(department), roles(roles){}

    unsigned getID() const{
        return id;
    }

    const std::shared_ptr<Department>& getDepartment() const {
        return department;
    }

    const std::string& getName() const{
        return name_user;
    }
    const std::shared_ptr<Roles>& getRole() const{
        return roles;
    }

    void setDepartment(const std::shared_ptr<Department>& depart){
        department = depart;
    }

    void setName(const std::string& name){
        name_user = name;
    }

    void setRole(const std::shared_ptr<Roles>& role){
        roles = role;
    }

};