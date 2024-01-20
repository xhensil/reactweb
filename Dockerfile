FROM node:19.6.0 as build
WORKDIR /frontend

COPY package*.json .
RUN npm config set legacy-peer-deps true
RUN npm install dotenv --save
RUN npm install -g env-cmd
RUN npm install
COPY . .

RUN npm run build:production
FROM nginx:1.19
COPY nginx/ngnix.conf /etc/nginx/nginx.conf
COPY --from=build /frontend/build /usr/share/nginx/html

EXPOSE 3000 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]