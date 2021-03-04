#!/bin/bash
set -e

echo Creating new DB...
mkdir -p $(dirname ${DB_DATABASE})
touch ${DB_DATABASE}

php composer.phar -q install

php artisan migrate:refresh
php artisan passport:install
php artisan storage:link
php artisan config:cache
echo DB was created