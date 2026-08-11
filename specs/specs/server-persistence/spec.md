# server-persistence

## Purpose

A separação em módulos `api`/`core` do `movie-sample-server`, e a
persistência com H2 (dev)/MySQL (docker) usando o mesmo changelog do
Liquibase como fonte única de verdade do schema.

## Requirements

### Requirement: Separação em módulos api e core

O repositório `movie-sample-server` SHALL ser organizado em dois módulos
Gradle: `api` (controllers, DTOs, validação, exception handling) e `core`
(domínio `Movie`, entidades JPA, repositórios de persistência). O módulo
`api` SHALL depender do `core`; o `core` SHALL NOT depender do `api`.

#### Scenario: Dependência entre módulos

- **WHEN** o projeto é compilado
- **THEN** o módulo `api` depende do módulo `core`, e o módulo `core` não
  referencia nenhuma classe do módulo `api`

### Requirement: Schema único via Liquibase entre H2 e MySQL

O schema do banco de dados SHALL ser definido por um único changelog do
Liquibase, aplicado tanto no perfil de desenvolvimento (H2) quanto no
perfil que usa MySQL, garantindo que o schema testado localmente seja o
mesmo usado no ambiente produção-like.

#### Scenario: Aplicação do schema em H2

- **WHEN** a aplicação sobe com o perfil de desenvolvimento (H2)
- **THEN** o changelog do Liquibase é aplicado e o schema resultante
  contém as tabelas e colunas do domínio `Movie`

#### Scenario: Aplicação do schema em MySQL

- **WHEN** a aplicação sobe com o perfil que usa MySQL (via Docker)
- **THEN** o mesmo changelog do Liquibase é aplicado, resultando no mesmo
  schema que o perfil de desenvolvimento

### Requirement: Persistência do Movie conforme o contrato de domínio

A entidade de persistência do `Movie` SHALL implementar fielmente os
campos, tipos e regras de validação definidos em `movie-domain-spec`
(identidade interna `Long` + `uuid` público, `titulo`, `ano`, `genero`,
`diretor`, `sinopse` como `TEXT`, `duracao`).

#### Scenario: Persistência de um Movie válido

- **WHEN** um `Movie` válido segundo `movie-domain-spec` é persistido
- **THEN** todos os seus campos são armazenados corretamente, incluindo o
  `id` interno gerado pelo banco e o `uuid` gerado na criação
