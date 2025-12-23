FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    g++ \
    make \
    libodb-dev \
    libodb-pgsql-dev \
    libpq-dev \
    libpqxx-dev \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/include/nlohmann && \
    wget -q https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp -O /usr/include/nlohmann/json.hpp

WORKDIR /app
COPY . /app

RUN g++ -std=c++17 \
    -I./include \
    -I./tables \
    -I./tables/orm \
    -I./tables/dto \
    -I./tables/mappers/read \
    -I./tables/mappers/write \
    -I/usr/include \
    main.cpp \
    routes/*.cpp \
    tables/orm/all_tables_single-odb.cxx \
    -o server_app \
    -lpthread \
    -lodb \
    -lodb-pgsql \
    -lpq \
    -lpqxx

EXPOSE 8081
CMD ["./server_app"]
