### Moodle

###dockerfile.moodle 
É utilizado para criar uma imagem do PHP 8.3 com Apache, que inclui várias extensões e configurações específicas para um ambiente de desenvolvimento. Aqui estão as principais características: -Definição da plataforma: A variável de ambiente TARGETPLATFORM é definida para compatibilidade com diferentes plataformas.

### dockerfile.sqlserver
Dockerfile é utilizado para criar uma imagem do SQL Server 2019, com configurações específicas para otimizar o desempenho e com scripts de entrada e configuração para inicializar o banco de dados.

###docker-compose.yml 
Este docker-compose define um ambiente composto por três serviços: Moodle, SQL Server e Portainer. Aqui estão as principais características de cada serviço:

- ####Serviço Moodle 
Imagem: Utiliza a imagem vicdron/moodle:latest. 
Portas: Expõe a porta 80 
Volumes: Monta dois volumes: um para o código-fonte do Moodle e outro para os dados do Moodle. 
Variáveis de ambiente: Define variáveis de ambiente para configurações do PHP, como número máximo de variáveis de entrada, tamanho máximo de upload e tamanho máximo de post.
- ####Serviço DB (SQL Server)
Imagem: Utiliza a imagem vicdron/moodle-sqlserver2019:latest. 
Portas: Expõe a porta 
Variáveis de ambiente: Define variáveis de ambiente para aceitar o EULA, definir uma senha forte para o usuário SA
Volumes: Monta um volume para os dados do SQL Server. 

- ####Serviço Portainer 
 Imagem: Utiliza a imagem portainer/portainer:latest. 
 Portas: Expõe a porta 9000 