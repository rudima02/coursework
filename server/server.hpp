#pragma once
#include <httplib.h>

class Server {
public:
    static httplib::Server& instance() {
        static httplib::Server server;
        return server;
    }
};
