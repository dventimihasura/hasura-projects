FROM postgres:14.7

WORKDIR /root
RUN apt-get -y update
RUN apt-get install postgresql-server-dev-14 -y
# RUN apt-get install postgresql-contrib -y
RUN apt-get install git -y
# RUN apt-get install default-jdk -y
RUN apt-get install gcc -y
# RUN apt-get install make -y
# RUN apt-get install wget -y
RUN apt-get install curl -y
# RUN apt-get install emacs -y
RUN apt-get install clang -y
RUN apt-get install pkg-config -y
# RUN apt-get install libpostgresql-jdbc-java -y
RUN apt-get install build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc ccache -y
# RUN git clone https://github.com/pgspider/jdbc_fdw.git
# WORKDIR /root/jdbc_fdw
# RUN ln -s /usr/lib/jvm/default-java/lib/server/libjvm.so /usr/lib/libjvm.so
# RUN make USE_PGXS=1
# RUN make install USE_PGXS=1
# WORKDIR /root
# RUN wget https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.13.20/snowflake-jdbc-3.13.20.jar
# RUN mv snowflake-jdbc-3.13.20.jar /usr/share/java
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN /root/.cargo/bin/cargo install --locked --version=0.6.1 cargo-pgx
RUN mkdir -p .pgx
COPY config.toml .pgx/config.toml
RUN git clone https://github.com/supabase/wrappers.git
WORKDIR /root/wrappers/wrappers
RUN /root/.cargo/bin/cargo pgx install --features clickhouse_fdw

