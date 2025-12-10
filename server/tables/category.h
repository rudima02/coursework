#pragma once
#include <string>
#include <vector>
#include <memory>
#include "odb/core.hxx"
#include "po.h"

class PO;

#pragma db object
class Category{

private:
    friend class odb::access;

#pragma db id auto
    unsigned long id;

    std::string name_category;

#pragma db inverse(category)
    std::vector<std::shared_ptr<PO>> programs;

public:
    Category() = default;
    Category(const std::string& name_category): name_category(name_category){}

    unsigned getId() const{
        return id;
    }
    
    const std::string& getName() const{
        return name_category;
    }

    const std::vector<std::shared_ptr<PO>>& getPrograms() const{
        return programs;
    }

    void setName(const std::string& name){
        name_category = name;
    }
    void setProgram(const std::shared_ptr<PO>& po){
        programs.emplace_back(po);
    }

};


