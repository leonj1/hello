FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy static files to nginx html directory
COPY . /usr/share/nginx/html/

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Railway dynamically assigns PORT via environment variable
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
