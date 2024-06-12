#!/usr/bin/env bash

set -e

# Verifica se a plataforma de destino é diferente de "linux/amd64"
if [[ ${TARGETPLATFORM} != "linux/amd64" ]]; then
    echo "A extensão sqlsrv não está disponível para a arquitetura ${TARGETPLATFORM}, pulando"
    exit 0
fi

# Pacotes necessários para a construção da extensão sqlsrv
BUILD_PACKAGES="gnupg unixodbc-dev"

# Pacotes necessários para o runtime do sqlsrv
PACKAGES_SQLSRV="unixodbc"

echo "Instalando dependências apt"

# Instala os pacotes necessários
apt-get update
apt-get install -y --no-install-recommends apt-transport-https $BUILD_PACKAGES $PACKAGES_SQLSRV

# Instala as dependências da Microsoft para sqlsrv
echo "Baixando e configurando os arquivos do sqlsrv"
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/debian/11/prod.list -o /etc/apt/sources.list.d/mssql-release.list
apt-get update

echo "Instalando msodbcsql"
ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Cria links simbólicos para as ferramentas do mssql
ln -fsv /opt/mssql-tools/bin/* /usr/bin

# Instala a extensão sqlsrv do PHP usando PECL e habilita-a
# É necessário usar a versão 5.9 (ou posterior) para suporte ao PHP 8.0
echo "Instalando e habilitando a extensão sqlsrv"
pecl install sqlsrv-5.11.0
docker-php-ext-enable sqlsrv

# Limpa o cache do PECL e remove pacotes de construção para reduzir o tamanho da imagem
echo "Limpando cache e removendo pacotes de construção"
pecl clear-cache
apt-get remove --purge -y $BUILD_PACKAGES
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Instalação e configuração da extensão sqlsrv concluída"
