FROM nginx:1.23.3-alpine

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy React build folder into nginx image
COPY mynotes/build /frontend

