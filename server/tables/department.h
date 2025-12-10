#pragma once 
#include <string>
#include <vector>
#include <memory>
#include "odb/core.hxx"
#include "pc.h"
#include "users.h"

class Users;
class PC;

#pragma db object
class Department{
private:
    friend class odb::access;

#pragma db id auto
    unsigned long id;

    std::string name_department; 

#pragma db inverse(department)
    std::vector<std::shared_ptr<PC>> pcs;

#pragma db inverse(department)
    std::vector<std::shared_ptr<Users>> users;

public: 
    Department()=default;
    Department(const std::string& name_department) : name_department(name_department){}

    unsigned getId() const{
        return id;
    }

    const std::string& getName() const{
        return name_department;
    }

    const std::vector<std::shared_ptr<PC>>& getPC() const{
        return pcs;
    }

    const std::vector<std::shared_ptr<Users>>& getUser() const{
        return users;
    }


    void setName(const std::string& name){
        name_department = name; 
    }

    void setPC(const std::shared_ptr<PC>& pc){
        pcs.emplace_back(pc);
    }
    void setUser(const std::shared_ptr<Users>& user){
        users.emplace_back(user);
    }

};