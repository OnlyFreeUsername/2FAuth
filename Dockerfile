FROM php:7.3

WORKDIR /app

# install zip unzip extensions for composer
RUN apt-get update \
	&& apt-get -y install zip unzip \
	&& rm -rf /var/lib/apt/lists/*

# install composer on top of php:7.3 for composer.lock compatibility
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');"

# $(php artisan key:generate) || $(head -c32 /dev/urandom | base64)

ENV APP_NAME=2FAuth \
	APP_ENV=local \
	APP_DEBUG=false \
	SITE_OWNER=mail@example.com \
	APP_KEY=SomeRandomStringOf32CharsExactly \
	APP_URL=0.0.0.0 \
	APP_PORT=80 \
	APP_TRIES=10 \
	DB_CONNECTION=sqlite \
	DB_DATABASE="/app/db/database.sqlite" \
	IS_DEMO_APP=false \
	LOG_CHANNEL=daily \
	APP_LOG_LEVEL=notice \
	CACHE_DRIVER=file \
	SESSION_DRIVER=file \
	MAIL_DRIVER=log \
	MAIL_HOST=smtp.mailtrap.io \
	MAIL_PORT=2525 \
	MAIL_FROM=changeme@example.com \
	MAIL_USERNAME=null \
	MAIL_PASSWORD=null \
	MAIL_ENCRYPTION=null \
	MAIL_FROM_NAME=null \
	MAIL_FROM_ADDRESS=null \
	BROADCAST_DRIVER=log \
	QUEUE_DRIVER=sync \
	SESSION_LIFETIME=12 \
	REDIS_HOST=127.0.0.1 \
	REDIS_PASSWORD=null \
	REDIS_PORT=6379 \
	PUSHER_APP_ID= \
	PUSHER_APP_KEY= \
	PUSHER_APP_SECRET= \
	PUSHER_APP_CLUSTER=mt1 \
	MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}" \
	MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}" \
	MIX_ENV=local

COPY . /app

RUN chmod +x initdb.sh && ./initdb.sh

ENTRYPOINT ["/app/entrypoint.sh"]