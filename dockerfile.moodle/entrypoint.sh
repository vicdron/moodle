#!/usr/bin/env bash
set -Eeo pipefail

# Log inicial da execução dos arquivos de entrada
echo "Executando arquivos de entrada em /docker-entrypoint.d/*"
docker_process_init_files /docker-entrypoint.d/*
echo

# Inicializando o PHP no Docker
echo "Iniciando moodle-php-entrypoint com $@"
source /usr/local/bin/docker-php-entrypoint
echo
