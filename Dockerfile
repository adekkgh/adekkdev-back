# Используем официальный PHP-образ с поддержкой необходимых расширений
FROM php:8.1-fpm

# Устанавливаем системные зависимости и расширения PHP
RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_pgsql

# Устанавливаем Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Устанавливаем рабочую директорию
WORKDIR /var/www

# Копируем файлы зависимостей
COPY composer.json composer.lock ./

# Устанавливаем PHP-зависимости
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Копируем остальные файлы проекта
COPY . .

# Даем права на папку storage и bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Открываем порт 8000
EXPOSE 8000

# Запускаем Laravel сервер
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
