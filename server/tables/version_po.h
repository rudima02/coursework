#pragma once
#include <string>
#include <memory>
#include "odb/core.hxx"
#include "po.h"
class PO;

#pragma db object
class VersionPO{
private: 
    friend class odb::access;

#pragma db id auto
    unsigned long id;

    std::string version;
    std::string date_version;


#pragma db not_null
#pragma db column("id_po")
    std::shared_ptr<PO> po;

public:
    VersionPO()=default;
    VersionPO(const std::string& version, const std::string& date_version, const std::shared_ptr<PO>& po ) : version(version), date_version(date_version)
                                                                                                                            ,po(po){}


    
    unsigned getID() const{
        return id;
    }

    const std::string& getVersion() const{
        return version;
    }
    const std::string& getDate() const{
        return date_version;
    }

    const std::shared_ptr<PO>& getPO() const{
        return po;
    }
    
    void setVersion(const std::string& vers){
        version = vers;
    }

    void setDate(const std::string& date){
        date_version = date;
    }

    void setPO(const std::shared_ptr<PO>& po_){
        po = po_;
    }
    
};
