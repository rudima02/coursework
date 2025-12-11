#pragma once
#include <string>

class VersionPODTO{
    unsigned long id;
    std::string version;
    std::string date_version;
    bool downloaded;
    unsigned long po_id;
};