#pragma once
#include <string>
#include <vector>
#include <memory>
#include "odb/core.hxx"
#include "category.h"
#include "version_po.h"
#include "semi.h"

class VersionPO;
class Category;
class Semi;

#pragma db object
class PO{
private:
    friend class odb::access;

#pragma db id auto
    unsigned long id;

    std::string name_po;

#pragma db not_null
#pragma db column("id_category")
    std::shared_ptr<Category> category;

#pragma db inverse(po)
    std::vector<std::shared_ptr<VersionPO>> versions;

#pragma db inverse(po)
    std::vector<std::shared_ptr<Semi>> semis;

public:
    PO()=default;
    PO(const std::string& name_po, const std::shared_ptr<Category>& category) : name_po(name_po), category(category){}

    unsigned getID() const{
        return id;
    }

    const std::string& getName() const{
        return name_po;
    }

    const std::shared_ptr<Category>& getCategory() const{
        return category;
    }

    const std::vector<std::shared_ptr<VersionPO>>& getVersion() const{
        return versions;
    }
    const std::vector<std::shared_ptr<Semi>>& getSemi() const{
        return semis;
    }

    void setName(const std::string& name){
        name_po = name;
    }

    void setCategory(const std::shared_ptr<Category>& categ){
        category = categ;
    }

    void setVersion(const std::shared_ptr<VersionPO>& vers){
        versions.emplace_back(vers);
    }

    void setSemi(const std::shared_ptr<Semi>& semi){
        semis.emplace_back(semi);
    }
};




