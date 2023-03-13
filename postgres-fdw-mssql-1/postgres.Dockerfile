FROM toleg/postgres_mssql_fdw:latest
WORKDIR /root
RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y \
    default-jdk \
    postgresql-server-dev-14 \
    gcc \
    make \
    unzip \
    libpostgresql-jdbc-java \
    git \
    wget \
    libmariadb3 \
    unixodbc \
    libodbc1 \
    odbcinst \
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
RUN wget https://github.com/microsoft/mssql-jdbc/releases/download/v12.2.0/mssql-jdbc-12.2.0.jre11.jar
# RUN unzip sqljdbc_12.2.0.0_enu.zip
RUN mv snowflake-jdbc-3.13.20.jar /usr/share/java
RUN mv ojdbc11.jar /usr/share/java
RUN mv mssql-jdbc-12.2.0.jre11.jar /usr/share/java
