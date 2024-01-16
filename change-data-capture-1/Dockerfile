FROM postgres:16
RUN apt-get update -y
RUN apt-get install postgresql-16-wal2json -y
RUN apt-get install postgresql-16-cron -y
RUN apt-get install jq -y
RUN apt-get install python3-pip postgresql-plpython3-16 pgxnclient -y
RUN apt-get install postgresql-server-dev-all -y
RUN pip install faker --break-system-packages
RUN pgxn install postgresql_faker
