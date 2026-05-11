FROM nginx:1.27-alpine

# index.html is the entire app.
COPY index.html /usr/share/nginx/html/index.html

# nginx:alpine auto-runs envsubst on files in /etc/nginx/templates/*.template
# at startup, writing the result to /etc/nginx/conf.d/. ${PORT} comes from
# Railway at runtime.
COPY default.conf.template /etc/nginx/templates/default.conf.template

ENV PORT=8080
EXPOSE 8080
