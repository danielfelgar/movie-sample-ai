## Why

O `movie-sample-server` é o backend que implementa o cadastro de filmes de fato — os endpoints de criar, listar, buscar por id, atualizar e remover filmes. Sem ele, o contrato de domínio já definido (`movie-domain-spec`) não tem implementação real, e o `movie-sample-gateway` não tem para onde rotear as requisições de `/api/movies`.

## What Changes

- Criar o repositório `movie-sample-server`: aplicação Spring Boot multi-módulo (`api`, `core`), Gradle Groovy DSL + TOML, Java 25, Spring Boot 4.1.0, Spring MVC + JPA.
- Implementar os endpoints REST de `Movie` (`GET/POST /api/movies`, `GET/PUT/DELETE /api/movies/{id}`) seguindo o contrato já publicado em `movie-domain-spec`, incluindo os status codes e o formato de erro (`ProblemDetail`, RFC 7807).
- Configurar persistência com H2 para desenvolvimento rápido e MySQL (via Docker) para o ambiente "produção-like", usando o mesmo changelog do Liquibase como fonte única de verdade do schema em ambos.
- Popular o banco com 200 filmes reais via Liquibase, usando um contexto/label de seed separado, para que os testes rodem contra uma base limpa.
- Expor a documentação da API via Swagger/OpenAPI (springdoc), habilitar Actuator health, e adicionar Dockerfile próprio.
- Criar a estrutura standalone do repositório (`AGENTS.md`, `CLAUDE.md`, `.ai/{skills,agents}`), seguindo o mesmo padrão dos demais subprojetos do workspace.

## Capabilities

### New Capabilities
- `server-movie-api`: os endpoints REST de `Movie` (criar, listar, buscar por id, atualizar, remover), seus status codes, e o formato de erro `ProblemDetail`, implementando o contrato de `movie-domain-spec`.
- `server-persistence`: a separação em módulos `api`/`core`, e a persistência com H2 (dev)/MySQL (docker) usando o mesmo changelog do Liquibase como fonte única de verdade do schema.
- `server-seed-data`: o seed de 200 filmes reais via Liquibase, isolado num contexto separado dos testes.
- `server-operations`: documentação da API via Swagger/OpenAPI, Actuator health, e Dockerfile.
- `server-repo-governance`: estrutura standalone do repositório `movie-sample-server` — `AGENTS.md`/`CLAUDE.md` próprios e `.ai/{skills,agents}` symlinkados, consistente com o padrão dos demais subprojetos do workspace.

### Modified Capabilities
(nenhuma — nenhuma spec existente muda de comportamento; este repositório implementa o contrato já definido em `movie-domain-spec`, sem alterá-lo)

## Impact

- Novo repositório `movie-sample-server`, criado como pasta irmã de `movie-sample-ai` e `movie-sample-gateway` no workspace.
- Torna o `movie-sample-gateway` funcionalmente completo do lado do backend — suas rotas de `/api/movies` agora têm um destino real.
- Nenhuma mudança em `movie-sample-ai`, `movie-sample-gateway` ou `movie-sample-front` além de tornar suas dependências (o server real) disponíveis.
