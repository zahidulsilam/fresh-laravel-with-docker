# Base image with Apache + PHP
FROM php:8.2-apache

# 1️⃣ Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev libzip-dev unzip zip git curl nodejs npm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2️⃣ Install PHP extensions needed by Laravel
RUN docker-php-ext-install pdo_mysql gd zip

# 3️⃣ Enable Apache rewrite module
RUN a2enmod rewrite

# 4️⃣ Set Laravel's public directory as document root
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

# 5️⃣ Copy Composer from official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6️⃣ Set working directory
WORKDIR /var/www/html

# 7️⃣ Copy Laravel app
COPY . .

# 8️⃣ Fix permissions for storage and cache
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# 9️⃣ Copy start.sh script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 10️⃣ Start Laravel + Apache
CMD ["/start.sh"]
