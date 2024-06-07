#!/usr/bin/env bash

set -e

# Verifica se a plataforma alvo não é "linux/amd64" e pula a instalação se for outra arquitetura
if [[ ${TARGETPLATFORM} != "linux/amd64" ]]; then
  echo "A extensão sqlsrv não está disponível para a arquitetura ${TARGETPLATFORM}, pulando instalação"
  exit 0
fi

# Pacotes necessários para a construção da extensão
BUILD_PACKAGES="gnupg unixodbc-dev"

# Pacotes necessários para o runtime do sqlsrv
PACKAGES_SQLSRV="unixodbc"

# Instala dependências necessárias
echo "Instalando dependências apt"
apt-get update
apt-get install -y --no-install-recommends apt-transport-https \
    $BUILD_PACKAGES \
    $PACKAGES_SQLSRV

# Baixa e adiciona chave da Microsoft para repositório do sqlsrv
echo "Baixando arquivos do sqlsrv"
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# Utiliza a configuração do Debian 10 (Buster) pois o pacote msodbcsql17 não está disponível para Debian 12 (Bookworm)
curl -sSL https://packages.microsoft.com/config/debian/10/prod.list -o /etc/apt/sources.list.d/mssql-release.list
apt-get update

# Instala msodbcsql
echo "Instalando msodbcsql"
# Mantém a versão 17 devido a problemas de compatibilidade com a versão 18
ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Cria links simbólicos para as ferramentas do mssql
ln -fsv /opt/mssql-tools/bin/* /usr/bin

# Instala e habilita a extensão sqlsrv 5.12.0 para suporte ao PHP 8.3
echo "Instalando e habilitando a extensão sqlsrv"
pecl install sqlsrv-5.12.0
docker-php-ext-enable sqlsrv

# Limpa cache do pecl e remove pacotes de construção para reduzir o tamanho da imagem
echo "Limpando cache e removendo pacotes de construção"
pecl clear-cache
apt-get remove --purge -y $BUILD_PACKAGES
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Instalação da extensão sqlsrv concluída"
