#!/usr/bin/env bash

set -e

if [[ ${TARGETPLATFORM} != "linux/amd64" ]]; then
  echo "sqlsrv extension not available for ${TARGETPLATFORM} architecture, skipping"
  exit 0
fi

# Pacotes necessários para a compilação e runtime
BUILD_PACKAGES="gnupg unixodbc-dev curl lsb-release"
PACKAGES_SQLSRV="unixodbc"

echo "Instalando dependências base do apt"
apt-get update
apt-get install -y --no-install-recommends apt-transport-https $BUILD_PACKAGES $PACKAGES_SQLSRV

# Instala as dependências da Microsoft para o SQL Server
echo "Adicionando o repositório da Microsoft para Debian 12 (Bookworm)"

# Adiciona a chave GPG da Microsoft
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/microsoft.gpg
chmod 644 /etc/apt/keyrings/microsoft.gpg

# Repositório oficial para Debian 12
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
    > /etc/apt/sources.list.d/mssql-release.list

apt-get update

# Instala a versão 17 do driver ODBC
echo "Instalando drivers da Microsoft (msodbcsql17) e ferramentas (mssql-tools)"
ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools

# Criando symlinks para as ferramentas de linha de comando
echo "Criando symlinks para as ferramentas de linha de comando"
ln -fsv /opt/mssql-tools/bin/* /usr/bin/

# Instala as extensões PHP via PECL (versão compatível com PHP 8.2)
echo "Instalando extensões PHP: sqlsrv e pdo_sqlsrv"
pecl install sqlsrv-5.11.1
pecl install pdo_sqlsrv-5.11.1

docker-php-ext-enable sqlsrv pdo_sqlsrv

# Limpa o cache para reduzir o tamanho da imagem
echo "Limpando o ambiente de build"
pecl clear-cache
apt-get remove --purge -y $BUILD_PACKAGES
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
