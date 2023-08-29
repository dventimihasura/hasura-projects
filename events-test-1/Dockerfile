FROM postgres:15
RUN apt-get update -y && \
    apt-get install postgresql-contrib -y && \
    apt-get install postgresql-server-dev-15 -y && \
    apt-get install git -y && \
    apt-get install build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc ccache -y && \
    apt-get install make -y
RUN git clone https://github.com/aws/postgresql-logfdw.git
WORKDIR postgresql-logfdw
RUN make clean USE_PGXS=1
RUN make USE_PGXS=1
RUN make install USE_PGXS=1



