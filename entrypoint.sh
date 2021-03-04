#!/bin/bash
set -e

if [ ! -f "${DB_DATABASE}" ]; then
	echo DB not found \(probably mounted as a volume\)\!
	./initdb.sh
fi

php artisan serve --host ${APP_URL} --port ${APP_PORT} --tries ${APP_TRIES}