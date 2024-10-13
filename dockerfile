# Use an official Nginx image to serve static content
FROM nginx:alpine

# Copy your HTML, CSS, and JavaScript files to the default Nginx location
COPY ./ /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80
