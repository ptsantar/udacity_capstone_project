FROM nginx:1.19.0

# Copy the index html to the nginx public directory
COPY my_site /usr/share/nginx/html/my_site 