#pragma once
#include <string>
#include <memory>
#include "odb/core.hxx"
#include "po.h"
#include "pc.h"

class PO;
class PC;

#pragma db object
class Semi{
private:
    friend class odb::access;

#pragma db id auto
    unsigned long id;

#pragma db not_null
#pragma db column("id_po")
    std::shared_ptr<PO> po;

#pragma db not_null
#pragma db column("id_pc")
    std::shared_ptr<PC> pc;

public:
    Semi()= default;
    Semi(const std::shared_ptr<PO>& po, const std::shared_ptr<PC>& pc) : po(po), pc(pc){}

    unsigned getID() const{
        return id;
    }

    const std::shared_ptr<PO>& getPO() const{
        return po;
    }
    const std::shared_ptr<PC>& getPC() const{
        return pc;
    }

    void setPO(const std::shared_ptr<PO>& po_){
        po = po_;
    }
    
    void setPC(const std::shared_ptr<PC>& pc_){
        pc = pc_;
    }

};