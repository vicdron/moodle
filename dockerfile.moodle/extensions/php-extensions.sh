#!/usr/bin/env bash
set -e

echo "=== Instalando pacotes do sistema ==="
apt-get update
apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libldap2-dev \
    libpng-dev \
    libxml2-dev \
    libxslt-dev \
    uuid-dev \
    libzip-dev \
    libsodium-dev \
    libmemcached-dev \
    ghostscript \
    libaio1 \
    libcurl4 \
    libgss3 \
    libicu72 \
    libxml2 \
    libxslt1.1 \
    sassc unzip zip

echo "=== Instalando extensões PHP nativas ==="
docker-php-ext-install -j"$(nproc)" \
    exif intl opcache soap xsl zip sodium gd ldap

docker-php-ext-configure gd --with-freetype --with-jpeg
docker-php-ext-install -j"$(nproc)" gd

docker-php-ext-configure ldap
docker-php-ext-install -j"$(nproc)" ldap

echo "=== Instalando extensões PECL ==="
pecl install apcu igbinary pcov solr timezonedb redis xdebug xhprof || true

echo "=== Habilitando extensões ==="
docker-php-ext-enable apcu igbinary pcov solr timezonedb redis xdebug xhprof

echo "=== Configurando PCov ==="
echo "pcov.enabled=0" >> /usr/local/etc/php/conf.d/10-docker-php-ext-pcov.ini
echo "pcov.exclude='~\/(tests|coverage|vendor|node_modules)\/~'" >> /usr/local/etc/php/conf.d/10-docker-php-ext-pcov.ini
echo "pcov.directory=." >> /usr/local/etc/php/conf.d/10-docker-php-ext-pcov.ini
echo "pcov.initial.files=1024" >> /usr/local/etc/php/conf.d/10-docker-php-ext-pcov.ini

echo "=== Limpando cache do PECL e APT ==="
pecl clear-cache
apt-get remove --purge -y libcurl4-openssl-dev libfreetype6-dev libicu-dev libjpeg62-turbo-dev \
    libldap2-dev libpng-dev libxml2-dev libxslt-dev uuid-dev libzip-dev libsodium-dev libmemcached-dev
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "=== Instalação das extensões PHP concluída ==="
