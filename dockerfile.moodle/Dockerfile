FROM php:8.2-apache-bookworm

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETARCH
ARG TARGETOS

# Debug - mostrar a plataforma durante o build
RUN echo "Construindo para TARGETPLATFORM=${TARGETPLATFORM}"
RUN echo "Arquitetura: ${TARGETARCH}, OS: ${TARGETOS}"

# Atualizando o apt-get e instalando pacotes úteis
RUN apt-get update && apt-get install -y \
    git \
    bc \
    vim \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Gerando as localidades UTF-8
ARG DEBIAN_FRONTEND=noninteractive
ADD locales-gen.sh /tmp/setup/locales-gen.sh
RUN chmod +x /tmp/setup/locales-gen.sh && /tmp/setup/locales-gen.sh

# Configurando as extensões PHP necessárias
ADD php-extensions.sh /tmp/setup/php-extensions.sh
RUN chmod +x /tmp/setup/php-extensions.sh && /tmp/setup/php-extensions.sh

# Instalar extensão PHP zip (com libzip-dev)
RUN apt-get update && apt-get install -y libzip-dev unzip \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-enable zip \
    && rm -rf /var/lib/apt/lists/*

# Instalando Microsoft SQLSRV
ADD sqlsrv-extensions.sh /tmp/setup/sqlsrv-extension.sh
RUN chmod +x /tmp/setup/sqlsrv-extension.sh && /tmp/setup/sqlsrv-extension.sh

# Criando diretórios necessários para o Moodle e ajustando permissões
RUN mkdir -p /var/www/moodledata /var/www/phpunitdata /var/www/behatdata /var/www/behatfaildumps && \
    chown www-data:www-data /var/www/moodledata /var/www/phpunitdata /var/www/behatdata /var/www/behatfaildumps

# Copia o arquivo de configuração personalizado
COPY custom-php.ini /usr/local/etc/php/conf.d/

# Corrigindo permissões do diretório /tmp, usado pelo PHP para uploads temporários
RUN chmod 777 /tmp && chmod +t /tmp

CMD ["apache2-foreground"]
