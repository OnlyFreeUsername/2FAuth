#!/bin/sh
set -e

mkdir -p /data
if [ ! -f .env ]; then
	cp /app/.env.example /data/.env
	ln -s /data/.env .env
	echo Please edit the the /data/.env file!
	echo docker exec -it $(hostname) vim /data/.env
	exit 1
fi

touch /data/database.sqlite
php artisan migrate:refresh
php artisan passport:install
php artisan storage:link
php artisan config:cache
echo Serving with arguments: ${@}
php artisan serve ${@}