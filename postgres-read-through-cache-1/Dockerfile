FROM postgres:14

WORKDIR /root
RUN apt-get -y update
RUN apt-get install git -y
RUN git clone https://github.com/pgspider/jdbc_fdw.git
WORKDIR /root/jdbc_fdw
RUN apt-get install -y default-jdk
RUN apt-get install postgresql-server-dev-14 -y
RUN ln -s /usr/lib/jvm/default-java/lib/server/libjvm.so /usr/lib/libjvm.so
RUN apt-get install gcc -y
RUN apt-get install make -y
RUN make USE_PGXS=1
RUN make install USE_PGXS=1
RUN apt-get install libpostgresql-jdbc-java -y

