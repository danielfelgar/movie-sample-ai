# server-seed-data

## Purpose

O seed de 200 filmes reais via Liquibase no `movie-sample-server`,
isolado num contexto separado dos testes.

## Requirements

### Requirement: Seed de 200 filmes reais

O changelog do Liquibase SHALL incluir um conjunto de changesets que
insere 200 filmes reais (dados verídicos de título, ano, gênero, diretor,
sinopse e duração — não fictícios), usando um contexto Liquibase dedicado
(ex: `seed`) separado dos changesets de schema.

#### Scenario: Inicialização em ambiente de desenvolvimento ou docker

- **WHEN** a aplicação sobe com o perfil de desenvolvimento (H2) ou com o
  perfil que usa MySQL, com o contexto `seed` ativo
- **THEN** o banco é populado com os 200 filmes reais definidos no
  changelog de seed

### Requirement: Testes isolados dos dados de seed

Os testes automatizados do server SHALL rodar com o contexto `seed` do
Liquibase desativado, de modo que a base de teste contenha apenas o
schema, sem os 200 filmes de seed.

#### Scenario: Execução da suíte de testes

- **WHEN** a suíte de testes REST Assured é executada
- **THEN** o banco de teste é inicializado apenas com o schema (via
  Liquibase, contexto `seed` desativado), sem os filmes de seed,
  permitindo asserções determinísticas sobre o estado da base
