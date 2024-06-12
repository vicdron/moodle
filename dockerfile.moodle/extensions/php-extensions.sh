#!/usr/bin/env bash

# Configura o script para sair imediatamente se um comando falhar
set -e

# Função para instalar pacotes usando apt-get
instalar_pacotes() {
  apt-get update
  apt-get install -y --no-install-recommends "$@"
}

echo "Instalando dependências apt"

# Pacotes necessários para a construção das extensões PHP
BUILD_PACKAGES="gettext libcurl4-openssl-dev libfreetype6-dev libicu-dev libjpeg62-turbo-dev \
  libldap2-dev libmariadb-dev libmemcached-dev libpng-dev libpq-dev libxml2-dev libxslt-dev \
  uuid-dev"

# Pacotes necessários para o runtime do Postgres
PACKAGES_POSTGRES="libpq5"

# Pacotes necessários para o runtime do MariaDB e MySQL
PACKAGES_MYMARIA="libmariadb3"

# Pacotes necessários para outras dependências de runtime do Moodle
PACKAGES_RUNTIME="ghostscript libaio1 libcurl4 libgss3 libicu67 libmcrypt-dev libxml2 libxslt1.1 \
  libzip-dev sassc unzip zip"

# Pacotes necessários para o Memcached
PACKAGES_MEMCACHED="libmemcached11 libmemcachedutil2"

# Pacotes necessários para o LDAP
PACKAGES_LDAP="libldap-2.4-2"

# Instala todos os pacotes necessários
instalar_pacotes $BUILD_PACKAGES $PACKAGES_POSTGRES $PACKAGES_MYMARIA $PACKAGES_RUNTIME $PACKAGES_MEMCACHED $PACKAGES_LDAP

echo "Instalando extensões PHP"

# Instala a extensão ZIP
docker-php-ext-configure zip --with-zip
docker-php-ext-install zip

# Instala extensões PHP comuns com paralelismo
docker-php-ext-install -j"$(nproc)" exif intl mysqli opcache pgsql soap xsl

# Configura e instala a extensão GD
echo "Configurando e instalando extensão GD"
docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
docker-php-ext-install -j"$(nproc)" gd

# Configura e instala a extensão LDAP
echo "Configurando e instalando extensão LDAP"
docker-php-ext-configure ldap
docker-php-ext-install -j"$(nproc)" ldap

# Instala e habilita extensões via PECL
echo "Instalando e habilitando extensões PECL: APCu, igbinary, memcached, mongodb, PCov, solr, timezonedb, uuid, XMLRPC (beta)"
pecl install apcu igbinary memcached mongodb pcov solr timezonedb uuid xmlrpc-beta
docker-php-ext-enable apcu igbinary memcached mongodb pcov solr timezonedb uuid xmlrpc

# Habilita a CLI do APCu
echo 'apc.enable_cli = On' >> /usr/local/etc/php/conf.d/10-docker-php-ext-apcu.ini

# Instala a extensão Redis com suporte ao igbinary
echo "Instalando extensão Redis com suporte ao igbinary"
pecl install --configureoptions 'enable-redis-igbinary="yes"' redis
docker-php-ext-enable redis

# Instala, mas não habilita, as extensões xdebug e xhprof
echo "Instalando extensões xdebug e xhprof"
pecl install xdebug xhprof

# Configurações para a extensão PCov
echo "Configurando PCov"
echo "pcov.enabled=0" >> /usr/local/etc/php/conf.d/10-docker-php-ext-pcov.ini
echo "pcov.exclude='~\/(tests|coverage|vendor|node_modules)\/~'" >> /usr/local/etc/php/conf.d/10-docker-php-ext-pcov.ini
echo "pcov.directory=." >> /usr/local/etc/php/conf.d/10-docker-php-ext-pcov.ini
echo "pcov.initial.files=1024" >> /usr/local/etc/php/conf.d/10-docker-php-ext-pcov.ini

# Limpa o cache do PECL e remove pacotes de construção para reduzir o tamanho da imagem
echo "Limpando cache e removendo pacotes de construção"
pecl clear-cache
apt-get remove --purge -y $BUILD_PACKAGES
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Instalação das extensões PHP concluída"
