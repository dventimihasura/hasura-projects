FROM node:18.16.0
RUN apt-get update -y
RUN apt-get install postgresql -y
RUN apt-get install postgresql-server-dev-all -y
# RUN npm i @nic-jennings/batched-sql-datasource
# RUN npm install knex --save
# RUN npm install pg-native --save
WORKDIR /app
COPY package*.json ./
COPY tsconfig*.json ./
RUN npm install
COPY src ./
CMD [ "npm", "start" ]
