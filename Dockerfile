# PHP 8.4 (stable; UserSpice's Composer deps need >= 8.2) on Debian 13 with apache + mod_php
FROM php:8.4-apache-trixie  
RUN apt-get update && apt-get install -y --no-install-recommends \
	libfreetype-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	libwebp-dev \
	libicu-dev \
	libzip-dev \
&& docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg \
&& docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli intl zip exif \
&& rm -rf /var/lib/apt/lists/*

COPY docker/apache/barrelbook.conf /etc/apache2/conf-available/barrelbook.conf

RUN a2enmod rewrite && a2enconf barrelbook

WORKDIR /var/www/html

# Copy needs a source and a destination
COPY src /var/www/html
RUN chown www-data:www-data /var/www/html/bourbon/images/uploads 

