FROM node:20.5.0-alpine3.18 as builder
WORKDIR /app
COPY . .
RUN [ "npm", "install", "-g", "pnpm" ]
RUN [ "pnpm", "install", "--frozen-lockfile" ]
RUN [ "pnpm", "run", "build"]

FROM nginx:1.25.1-alpine3.17
RUN rm -rf /usr/share/nginx/html/* && \
    sed -i '12i \ \ \ \ \ location /ping {\n        return 200;\n        access_log off;\n    }\n' /etc/nginx/conf.d/default.conf && \
    sed -i 's/#access_log  \/var\/log\/nginx\/host.access.log/access_log \/var\/log\/nginx\/access.log/' /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
