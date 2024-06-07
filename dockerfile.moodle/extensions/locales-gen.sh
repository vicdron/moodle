#!/usr/bin/env bash

set -e

echo "Instalando dependências apt"

# Pacotes para instalar locales
RUNTIME_LOCALES="locales"

# Atualiza os repositórios e instala os pacotes necessários
apt-get update
apt-get install -y --no-install-recommends apt-transport-https \
    $RUNTIME_LOCALES

echo "Instalando locales UTF-8"
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen

# Gera os locales especificados
locale-gen

# Limpa o cache do apt e remove pacotes não utilizados para reduzir o tamanho da imagem
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Configuração de locales concluída"
