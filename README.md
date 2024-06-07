
#Moodle

dockerfile.moodle
É utilizado para criar uma imagem do PHP 8.3 com Apache, que inclui várias extensões e configurações específicas para um ambiente de desenvolvimento. Aqui estão as principais características:
-Definição da plataforma: A variável de ambiente TARGETPLATFORM é definida para compatibilidade com diferentes plataformas.
-Atualização e instalação de pacotes: O Dockerfile atualiza o apt-get e instala pacotes úteis como Git, Vim e remove as listas de pacotes.
-Gerenciamento de localidades: O script locales-gen.sh é executado para gerar localidades UTF-8.
-Configuração de extensões PHP: O script php-extensions.sh é executado para configurar as extensões PHP necessárias.
-Instalação de Oracle Instantclient e Microsoft SQLSRV: Os scripts oci8-extension.sh e sqlsrv-extension.sh são executados para instalar essas extensões.
-Criando diretórios e ajustando permissões: Os diretórios necessários para o Moodle e ajustando permissões são criados.
-Corrigindo permissões do diretório /tmp: As permissões do diretório /tmp são ajustadas para permitir uploads temporários.
-Comando de execução: O comando apache2-foreground é executado para iniciar o Apache em segundo plano.

dockerfile.sqlserver
Dockerfile é utilizado para criar uma imagem do SQL Server 2019, com configurações específicas para otimizar o desempenho e com scripts de entrada e configuração para inicializar o banco de dados. Aqui estão as principais características:
-Definição do usuário: O usuário root é definido para executar os comandos do Dockerfile.
-Configurações do SQL Server: Comandos são executados para configurar o SQL Server para otimizar o desempenho.
-Adicionando arquivos locais: Arquivos da pasta local 'root' são adicionados à raiz do sistema de arquivos no container.
-Copia de scripts: O script de entrada entrypoint.sh e o arquivo SQL setup.sql são copiados para o container.
-Permissões do script de entrada: As permissões do script de entrada são ajustadas para que ele possa ser executado.
-Porta de exposição: A porta 1433 é exposta para que o SQL Server possa ser acessado.
-Definição do usuário: O usuário mssql é definido para executar o script de entrada.
-Comando de execução: O script de entrada é executado como comando padrão do container.

docker-compose.yml
Este docker-compose define um ambiente composto por três serviços: Moodle, SQL Server e Portainer. Aqui estão as principais características de cada serviço:
-Serviço Moodle
Imagem: Utiliza a imagem vicdron/moodle:latest.
Portas: Expõe a porta 80 do container para a porta 80 do host.
Volumes: Monta dois volumes: um para o código-fonte do Moodle e outro para os dados do Moodle.
Variáveis de ambiente: Define variáveis de ambiente para configurações do PHP, como número máximo de variáveis de entrada, tamanho máximo de upload e tamanho máximo de post.
Rede: Conecta o serviço à rede moodle_net.
-Serviço DB (SQL Server)
Imagem: Utiliza a imagem vicdron/moodle-sqlserver2019:latest.
Portas: Expõe a porta 1433 do container para a porta 1433 do host.
Variáveis de ambiente: Define variáveis de ambiente para aceitar o EULA, definir uma senha forte para o usuário SA e adicionar a capacidade SYS_PTRACE.
Volumes: Monta um volume para os dados do SQL Server.
Rede: Conecta o serviço à rede moodle_net.
-Serviço Portainer
Imagem: Utiliza a imagem portainer/portainer:latest.
Nome do container: Define o nome do container como portainer.
Portas: Expõe a porta 9000 do container para a porta 9000 do host.
Volumes: Monta três volumes: um para o socket do Docker, outro para os dados do Portainer e outro para os logs e configurações do Portainer.
Reinicialização: Define a política de reinicialização como always.
Rede: Conecta o serviço à rede moodle_net.