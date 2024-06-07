FROM php:8.3-apache-bookworm

# Definindo a plataforma alvo como uma variável de ambiente para compatibilidade com diferentes plataformas
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}
RUN echo "Construindo para ${TARGETPLATFORM}"

# Atualizando o apt-get e instalando pacotes úteis
RUN apt-get update && apt-get install -y \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Gerando as localidades UTF-8
ARG DEBIAN_FRONTEND=noninteractive
ADD extensions/locales-gen.sh /tmp/setup/locales-gen.sh
RUN chmod +x /tmp/setup/locales-gen.sh && /tmp/setup/locales-gen.sh

# Configurando as extensões PHP necessárias
ADD extensions/php-extensions.sh /tmp/setup/php-extensions.sh
RUN chmod +x /tmp/setup/php-extensions.sh && /tmp/setup/php-extensions.sh

# Instalando Oracle Instantclient
ADD extensions/oci8-extension.sh /tmp/setup/oci8-extension.sh
RUN chmod +x /tmp/setup/oci8-extension.sh && /tmp/setup/oci8-extension.sh
ENV LD_LIBRARY_PATH /usr/local/instantclient

# Instalando Microsoft SQLSRV
ADD extensions/sqlsrv-extension.sh /tmp/setup/sqlsrv-extension.sh
RUN chmod +x /tmp/setup/sqlsrv-extension.sh && /tmp/setup/sqlsrv-extension.sh

# Criando diretórios necessários para o Moodle e ajustando permissões
RUN mkdir -p /var/www/moodledata /var/www/phpunitdata /var/www/behatdata /var/www/behatfaildumps && \
    chown www-data:www-data /var/www/moodledata /var/www/phpunitdata /var/www/behatdata /var/www/behatfaildumps

# Corrigindo permissões do diretório /tmp, usado pelo PHP para uploads temporários
RUN chmod 777 /tmp && chmod +t /tmp

CMD ["apache2-foreground"]

