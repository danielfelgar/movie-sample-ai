# server-operations

## Purpose

Operação do `movie-sample-server`: documentação da API via
Swagger/OpenAPI, health check via Actuator, e a imagem Docker que
empacota a aplicação.

## Requirements

### Requirement: Documentação da API via OpenAPI

O server SHALL expor a documentação de sua API via Swagger/OpenAPI
(springdoc), refletindo automaticamente os endpoints, DTOs e formato de
erro `ProblemDetail`.

#### Scenario: Acesso à documentação da API

- **WHEN** a documentação OpenAPI do server é acessada
- **THEN** ela lista os endpoints de `/api/movies`, seus parâmetros,
  corpos de request/response e os possíveis status codes de erro

### Requirement: Health check via Actuator

O server SHALL expor um endpoint de health check via Spring Boot Actuator
em `/actuator/health`.

#### Scenario: Verificação de saúde do server

- **WHEN** uma requisição `GET /actuator/health` é feita ao server
- **THEN** o server responde com o status de saúde da aplicação,
  incluindo a conectividade com o banco de dados

### Requirement: Imagem Docker do server

O repositório `movie-sample-server` SHALL conter um Dockerfile que
produz uma imagem executável da aplicação a partir de um build
multi-stage (build via Gradle, runtime em uma imagem leve).

#### Scenario: Build da imagem Docker do server

- **WHEN** o Dockerfile do `movie-sample-server` é construído
- **THEN** o resultado é uma imagem capaz de executar a aplicação do
  server, pronta para ser referenciada pelo `docker-compose.yml` do
  `movie-sample-ai`
