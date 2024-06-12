#!/usr/bin/env bash

set -e

# Verifica se a plataforma de destino é diferente de "linux/amd64"
if [[ ${TARGETPLATFORM} != "linux/amd64" ]]; then
    echo "Extensão Oracle não está disponível para a arquitetura ${TARGETPLATFORM}, pulando"
    exit 0
fi

echo "Baixando arquivos do Oracle"

# URLs dos arquivos Oracle
ORACLE_URL_BASE="https://download.oracle.com/otn_software/linux/instantclient/216000"
BASIC_ZIP="instantclient-basic-linux.x64-21.6.0.0.0dbru.zip"
SDK_ZIP="instantclient-sdk-linux.x64-21.6.0.0.0dbru.zip"
SQLPLUS_ZIP="instantclient-sqlplus-linux.x64-21.6.0.0.0dbru.zip"

# Diretório temporário para download
TMP_DIR="/tmp"
ORACLE_DIR="/usr/local"

# Baixa os arquivos necessários
curl -o "${TMP_DIR}/${BASIC_ZIP}" "${ORACLE_URL_BASE}/${BASIC_ZIP}"
curl -o "${TMP_DIR}/${SDK_ZIP}" "${ORACLE_URL_BASE}/${SDK_ZIP}"
curl -o "${TMP_DIR}/${SQLPLUS_ZIP}" "${ORACLE_URL_BASE}/${SQLPLUS_ZIP}"

# Extrai os arquivos baixados
unzip "${TMP_DIR}/${BASIC_ZIP}" -d "${ORACLE_DIR}"
rm "${TMP_DIR}/${BASIC_ZIP}"
unzip "${TMP_DIR}/${SDK_ZIP}" -d "${ORACLE_DIR}"
rm "${TMP_DIR}/${SDK_ZIP}"
unzip "${TMP_DIR}/${SQLPLUS_ZIP}" -d "${ORACLE_DIR}"
rm "${TMP_DIR}/${SQLPLUS_ZIP}"

# Cria links simbólicos para facilitar o acesso
ln -s "${ORACLE_DIR}/instantclient_21_6" "${ORACLE_DIR}/instantclient"
ln -s "${ORACLE_DIR}/instantclient/sqlplus" /usr/bin/sqlplus

# Instala a extensão OCI8 do Oracle usando PECL e habilita-a no PHP
echo 'instantclient,/usr/local/instantclient' | pecl install oci8-3.0.1
docker-php-ext-enable oci8

# Configura a extensão OCI8
echo 'oci8.statement_cache_size = 0' >> /usr/local/etc/php/conf.d/docker-php-ext-oci8.ini

echo "Instalação e configuração da extensão OCI8 concluída"
