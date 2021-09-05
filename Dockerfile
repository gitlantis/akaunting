FROM webdevops/php-nginx:7.4-alpine

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

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV WEB_DOCUMENT_ROOT /app
ENV APP_ENV production
WORKDIR /app
COPY . .

RUN composer install --no-plugins --no-scripts --no-interaction --optimize-autoloader --no-dev
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache 
RUN chmod -R 777 storage && chmod -R 777 bootstrap/cache
