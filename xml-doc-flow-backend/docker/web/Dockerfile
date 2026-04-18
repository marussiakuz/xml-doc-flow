# Контекст сборки — корень монорепозитория (родитель каталога xml-doc-flow-backend), см. docker-compose.yml
FROM nginx:1.27-alpine

COPY xml-doc-flow-backend/docker/web/default.conf /etc/nginx/conf.d/default.conf
COPY xml-doc-flow-frontend/ /usr/share/nginx/html/
