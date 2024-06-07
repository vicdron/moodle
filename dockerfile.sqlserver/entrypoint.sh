#!/usr/bin/env bash

set -e

# Função para aguardar o SQL Server ficar disponível
wait_for_sql_server() {
    local retries=60
    local wait=1

    echo "[moodle-db-mssql] Iniciando a espera pelo SQL Server..."

    for ((i=0; i<retries; i++)); do
        if /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -l 1 -Q "SELECT 1" > /dev/null 2>&1; then
            echo "[moodle-db-mssql] SQL Server disponível"
            return 0
        fi
        echo "[moodle-db-mssql] Aguardando o SQL Server aceitar conexões (tentativa $((i+1))/$retries)..."
        sleep $wait
    done

    echo "[moodle-db-mssql] Tempo esgotado esperando o servidor aceitar conexões"
    exit 1
}

# Inicia o SQL Server em segundo plano
echo "[moodle-db-mssql] Iniciando o SQL Server..."
/opt/mssql/bin/sqlservr &

# Aguarda o SQL Server ficar disponível
wait_for_sql_server

# Configura o banco de dados para o Moodle
echo "[moodle-db-mssql] Configurando o banco de dados do Moodle..."
if /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -i setup.sql; then
    echo "[moodle-db-mssql] Configuração do Moodle concluída."
else
    echo "[moodle-db-mssql] Erro na configuração do Moodle."
    exit 1
fi

# Mantém o container em execução
echo "[moodle-db-mssql] Mantendo o container em execução..."
wait
