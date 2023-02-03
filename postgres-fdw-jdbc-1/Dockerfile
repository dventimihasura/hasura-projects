FROM hasura/graphql-engine:latest

FROM postgres:14
WORKDIR /root
RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y \
    default-jdk \
    postgresql-server-dev-14 \
    gcc \
    make \
    libpostgresql-jdbc-java \
    git \
    wget \
    libmariadb3 \
    libmariadb-java \
    libpostgresql-jdbc-java
RUN git clone https://github.com/pgspider/jdbc_fdw.git
WORKDIR /root/jdbc_fdw
RUN ln -s /usr/lib/jvm/default-java/lib/server/libjvm.so /usr/lib/libjvm.so
RUN C_INCLUDE_PATH=/usr/include/postgresql/14/server make USE_PGXS=1
RUN C_INCLUDE_PATH=/usr/include/postgresql/14/server make install USE_PGXS=1
WORKDIR /
RUN wget https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.13.20/snowflake-jdbc-3.13.20.jar
RUN wget https://download.oracle.com/otn-pub/otn_software/jdbc/218/ojdbc11.jar
RUN mv snowflake-jdbc-3.13.20.jar /usr/share/java
RUN mv ojdbc11.jar /usr/share/java
COPY --from=0 /usr/bin/graphql-engine /usr/bin
ENV HGE_BINARY graphql-engine
ENV POSTGRES_PASSWORD postgrespassword
ENV HASURA_GRAPHQL_DATABASE_URL postgresql://postgres:postgrespassword@127.0.0.1:5432/postgres
COPY 01_hasura.sh /docker-entrypoint-initdb.d
COPY 02_init.sh /docker-entrypoint-initdb.d
