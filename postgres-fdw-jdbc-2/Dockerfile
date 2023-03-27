FROM postgres:14

WORKDIR /root
RUN apt-get -y update
RUN apt-get install git -y
RUN apt-get install default-jdk -y
RUN apt-get install postgresql-server-dev-14 -y
RUN apt-get install gcc -y
RUN apt-get install make -y
RUN apt-get install libpostgresql-jdbc-java -y
RUN git clone https://github.com/pgspider/jdbc_fdw.git
WORKDIR /root/jdbc_fdw
RUN ln -s /usr/lib/jvm/default-java/lib/server/libjvm.so /usr/lib/libjvm.so
RUN make USE_PGXS=1
RUN make install USE_PGXS=1
RUN apt-get install wget -y
WORKDIR /
RUN wget https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.13.20/snowflake-jdbc-3.13.20.jar
RUN mv snowflake-jdbc-3.13.20.jar /usr/share/java
