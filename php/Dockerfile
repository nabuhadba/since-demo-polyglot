FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --no-scripts

FROM php:8.1-fpm-alpine
WORKDIR /var/www/invoices
COPY --from=vendor /app/vendor ./vendor
COPY . .
EXPOSE 9000
CMD ["php-fpm"]
