#!/usr/bin/env bash

set -e

# Verifica se a plataforma alvo não é "linux/amd64" e pula a instalação se for outra arquitetura
if [[ ${TARGETPLATFORM} != "linux/amd64" ]]; then
    echo "A extensão oci8 não está disponível para a arquitetura ${TARGETPLATFORM}, pulando instalação"
    exit 0
fi

echo "Baixando arquivos do Oracle"
# URLs dos arquivos Oracle Instant Client
URL_BASIC="https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-basic-linux.x64-21.6.0.0.0dbru.zip"
URL_SDK="https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-sdk-linux.x64-21.6.0.0.0dbru.zip"
URL_SQLPLUS="https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-sqlplus-linux.x64-21.6.0.0.0dbru.zip"

# Diretório temporário
TMP_DIR="/tmp"

# Baixa os arquivos Oracle Instant Client
curl -sSL $URL_BASIC -o $TMP_DIR/instantclient-basic-linux.x64-21.6.0.0.0dbru.zip
curl -sSL $URL_SDK -o $TMP_DIR/instantclient-sdk-linux.x64-21.6.0.0.0dbru.zip
curl -sSL $URL_SQLPLUS -o $TMP_DIR/instantclient-sqlplus-linux.x64-21.6.0.0.0dbru.zip

echo "Extraindo arquivos Oracle Instant Client"
# Extrai os arquivos Oracle Instant Client
unzip -q $TMP_DIR/instantclient-basic-linux.x64-21.6.0.0.0dbru.zip -d /usr/local/
rm $TMP_DIR/instantclient-basic-linux.x64-21.6.0.0.0dbru.zip

unzip -q $TMP_DIR/instantclient-sdk-linux.x64-21.6.0.0.0dbru.zip -d /usr/local/
rm $TMP_DIR/instantclient-sdk-linux.x64-21.6.0.0.0dbru.zip

unzip -q $TMP_DIR/instantclient-sqlplus-linux.x64-21.6.0.0.0dbru.zip -d /usr/local/
rm $TMP_DIR/instantclient-sqlplus-linux.x64-21.6.0.0.0dbru.zip

# Cria links simbólicos para a pasta Instant Client
ln -s /usr/local/instantclient_21_6 /usr/local/instantclient
ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus

echo "Instalando e habilitando a extensão oci8"
# Instala e habilita a extensão oci8
echo 'instantclient,/usr/local/instantclient' | pecl install oci8
docker-php-ext-enable oci8

# Configurações adicionais da extensão oci8
echo 'oci8.statement_cache_size = 0' >> /usr/local/etc/php/conf.d/docker-php-ext-oci8.ini

echo "Instalação da extensão oci8 concluída"
