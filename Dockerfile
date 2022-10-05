FROM --platform=linux/amd64 node:16-alpine3.16

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8000
CMD [ "node", "index.js" ]