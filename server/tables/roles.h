#pragma once
#include <string>
#include <vector>
#include <memory>
#include "odb/core.hxx"
#include "users.h"

class Users;

#pragma db object
class Roles{
private:
    friend class odb::access;

#pragma db id auto
    unsigned long id;

    std::string name_role;

#pragma db inverse(roles)
    std::vector<std::shared_ptr<Users>> users;

public:
    Roles() = default;
    Roles(const std::string& name_role): name_role(name_role){}

    unsigned getID() const{
        return id;
    }

    const std::string& getName() const{
        return name_role;
    }

    const std::vector<std::shared_ptr<Users>>& getUser() const{
        return users;
    }

    void setName(const std::string& name){
        name_role = name;
    }

    void setUser(const std::shared_ptr<Users>& user){
        users.emplace_back(user);
    }
};


