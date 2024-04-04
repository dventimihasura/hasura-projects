FROM postgres:16

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y wget
RUN apt-get install -y cmake
RUN apt-get install -y librust-openssl-dev
RUN apt-get install -y postgresql-server-dev-16
RUN apt-get install -y libcurl4-openssl-dev make g++

RUN wget https://github.com/EnterpriseDB/mongo_fdw/archive/refs/tags/REL-5_5_1.tar.gz && \
    tar -xzf REL-5_5_1.tar.gz && \
    rm -rf mongo_fdw && \
    mv mongo_fdw-REL-5_5_1 mongo_fdw && \
    cd mongo_fdw && \
    ./autogen.sh --with-master && \
    make USE_PGXS=1 && \
    make USE_PGXS=1 install

RUN wget https://github.com/pramsey/pgsql-http/archive/refs/tags/v1.6.0.tar.gz && \
    tar -xzvf v1.6.0.tar.gz && \
    rm -rf pgsql-http && \
    mv pgsql-http-1.6.0 pgsql-http && \
    cd pgsql-http && \
    make USE_PGXS=1 && \
    make USE_PGXS=1 install
