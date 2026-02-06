#!/bin/sh -x
set -e

cd /var/www/html

# Install dependencies if vendor folder is missing
if [ ! -d vendor ]; then
    echo "Installing Composer dependencies..."
     composer install --no-interaction --prefer-dist
fi

# env file rename

if [ ! -f ".env" ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    # Generate key since this is a new .env
    php artisan key:generate --force
else
    echo ".env file already exists."
fi

php artisan migrate --force

# ✅ Start Apache in foreground (crucial!)
apache2-foreground