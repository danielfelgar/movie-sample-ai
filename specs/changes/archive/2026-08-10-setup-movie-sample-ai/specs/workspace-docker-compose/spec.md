## ADDED Requirements

### Requirement: Localização do docker-compose unificado
O `docker-compose.yml` que orquestra os serviços do workspace SHALL ser versionado dentro do repositório `movie-sample-ai`, e não na raiz do `workspace` (que não é versionada em git) nem em nenhum dos repositórios de aplicação individualmente.

#### Scenario: Colaborador procura o docker-compose do workspace
- **WHEN** alguém quer subir todos os serviços do workspace via Docker Compose
- **THEN** encontra o arquivo `docker-compose.yml` dentro do repositório `movie-sample-ai`

### Requirement: Esqueleto de serviços do workspace
O `docker-compose.yml` SHALL declarar um serviço para cada componente do workspace — `movie-sample-gateway`, `movie-sample-server`, `movie-sample-front` e o banco de dados (`mysql`) — mesmo antes de esses repositórios de aplicação possuírem Dockerfiles prontos, servindo como esqueleto a ser refinado quando eles existirem.

#### Scenario: docker-compose criado antes dos repositórios de aplicação existirem
- **WHEN** o `docker-compose.yml` é criado como parte desta mudança, e `movie-sample-gateway`, `movie-sample-server` e `movie-sample-front` ainda não existem como repositórios implementados
- **THEN** o arquivo já declara a estrutura de serviços esperada (gateway, server, front, mysql), ainda que os detalhes de build/imagem desses serviços sejam completados em mudanças futuras
