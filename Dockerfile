# FROM ubuntu/nginx

# # FROM php:7.2-fpm

# #RUN php artisan install --db-name=${DB_DATABASE} --db-username=${DB_USERNAME} --db-password=${DB_PASSWORD} --admin-email=${ADMIN_USER} --admin-password=${ADMIN_PASSWORD}
# RUN apt-get update
# RUN apt-get install systemd -y
# RUN apt-get install php-fpm -y
# WORKDIR /usr/src/app
# COPY . .
# COPY akaunting.service /etc/systemd/system/
# COPY default /etc/nginx/sites-available
# RUN systemctl enable akaunting.service

##RUN php -S 127.0.0.1:8888

FROM webdevops/php-nginx:7.4-alpine

# Install Laravel framework system requirements (https://laravel.com/docs/8.x/deployment#optimizing-configuration-loading)
RUN apk add oniguruma-dev libxml2-dev
RUN docker-php-ext-install \
        bcmath \
        ctype \
        fileinfo \
        json \
        mbstring \
        pdo_mysql \
        tokenizer \
        xml

# Copy Composer binary from the Composer official Docker image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV WEB_DOCUMENT_ROOT /app
ENV APP_ENV production
WORKDIR /app
COPY . .

RUN composer install --no-plugins --no-scripts --no-interaction --optimize-autoloader --no-dev
# Optimizing Configuration loading
RUN php artisan config:cache
# Optimizing Route loading
RUN php artisan route:cache
# Optimizing View loading
RUN php artisan view:cache
#RUN php -S localhost:8080
RUN chmod -R 777 storage && chmod -R 777 bootstrap/cache
#RUN php artisan install --db-host="db" --db-port=3306 --db-name="akaunting" --db-username="root" --db-password="" --admin-email="admin@company.com" --admin-password="123456"
#RUN chown nginx:nginx .