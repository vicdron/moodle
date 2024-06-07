FROM mcr.microsoft.com/mssql/server:2019-latest

USER root

# Configurações do SQL Server para otimização de desempenho
RUN /opt/mssql/bin/mssql-conf traceflag 3979 on && \
    /opt/mssql/bin/mssql-conf set control.alternatewritethrough 0 && \
    /opt/mssql/bin/mssql-conf set control.writethrough 0

# Adiciona arquivos da pasta local 'root' para a raiz do sistema de arquivos no container
#ADD root/ /

# Copia o script de entrada e o arquivo sql
COPY entrypoint.sh /entrypoint.sh
COPY setup.sql /setup.sql
RUN chmod +x /entrypoint.sh

EXPOSE 1433

USER mssql

CMD ["/entrypoint.sh"]


