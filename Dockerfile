FROM php:8.2-apache

# 1. Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev libzip-dev unzip zip git

# 2. Install PHP extensions
RUN docker-php-ext-install pdo_mysql gd zip

# 3. Apache Config
RUN a2enmod rewrite
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 4. Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock ./
# install node and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && node -v \
    && npm -v \
    && echo "Node & npm installed successfully"
WORKDIR /var/www/html
COPY . .
# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Run start.sh at container start
CMD ["/start.sh"]

