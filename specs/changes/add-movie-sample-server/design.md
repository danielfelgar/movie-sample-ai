## Context

O `movie-sample-server` é o terceiro repositório do workspace a ser implementado, depois de `movie-sample-ai` e `movie-sample-gateway`. Ele implementa o contrato já publicado em `openspec/specs/movie-domain-spec` — campos, tipos e regras de validação do `Movie` já estão decididos; este design cobre apenas como implementá-los. `movie-sample-front` ainda não existe, então o consumo real da API pelo front é uma mudança futura; este repositório é testável de forma independente via os próprios testes REST Assured contra H2.

## Goals / Non-Goals

**Goals:**
- Implementar o CRUD completo de `Movie` (create, list, get by id, update, delete) exatamente como especificado em `movie-domain-spec` e nas rotas já definidas em `movie-sample-gateway` (`gateway-routing`).
- Separar `api` (camada web: controllers, DTOs, validação, exception handling) de `core` (domínio + persistência), com `core` incluindo a camada de persistência (Opção A da exploração — sem um terceiro módulo de infraestrutura).
- Garantir que o schema do banco seja idêntico entre H2 (dev) e MySQL (docker), usando o mesmo changelog do Liquibase.
- Popular a base com 200 filmes reais na inicialização, sem contaminar os testes automatizados com esses dados.

**Non-Goals:**
- Paginação na listagem — é uma feature futura, intencionalmente fora de escopo (listagem retorna todos os filmes).
- Qualquer regra de negócio além dos campos e validações já definidos em `movie-domain-spec` (ex: unicidade de título) — não há restrição adicional.
- Testes de integração com Testcontainers/MySQL real — os testes deste repositório rodam contra H2.
- Autenticação/autorização nos endpoints — fora do escopo deste projeto de artigo.

## Decisions

### 1. Módulos `api`/`core` (Opção A — core inclui persistência)
`api` contém controllers, DTOs de request/response, validação (Bean Validation) e exception handling. `core` contém o domínio (`Movie`), a lógica de aplicação, as entidades JPA e os repositórios Spring Data. Não há um terceiro módulo de infraestrutura separado — decisão já tomada na exploração para manter a estrutura simples e didática (o projeto é para um artigo).

**Alternativa considerada:** separar persistência num módulo de infraestrutura à parte (mais "hexagonal"). Rejeitada por adicionar complexidade que não se paga no contexto de um projeto de exemplo/artigo.

### 2. Identidade dupla: `id` interno (`Long`) e `uuid` exposto como `id` na API
Conforme `movie-domain-spec`, a entidade JPA usa `Long` autoincrement como chave primária interna (eficiência de índice/join), e um `UUID` gerado na criação como identificador público. Os DTOs de resposta expõem esse UUID no campo JSON `id` — o cliente da API nunca vê o `Long` interno.

### 3. Liquibase como schema único entre H2 e MySQL
O mesmo changelog roda em ambos os perfis (`dev` com H2, `docker` com MySQL), eliminando divergência entre o que é testado localmente e o que roda em produção-like. O seed de 200 filmes usa um **contexto Liquibase separado** (ex: `context="seed"`), ativado nos perfis `dev`/`docker` mas não no perfil de teste — os testes REST Assured partem de uma base com schema pronto, mas sem dados de seed, permitindo asserções determinísticas.

### 4. Erros via `ProblemDetail` (RFC 7807) nativo do Spring Boot
Em vez de um formato de erro customizado, usa-se o suporte nativo do Spring Boot 4.1 a `ProblemDetail`, documentado automaticamente no Swagger. Menor esforço de implementação e já é um padrão reconhecido.

### 5. Status codes por operação
`POST /api/movies` → `201 Created` com header `Location`; `PUT /api/movies/{id}` → `200 OK` com o recurso atualizado; `DELETE /api/movies/{id}` → `204 No Content`; qualquer busca por id inexistente → `404` via `ProblemDetail`.

## Risks / Trade-offs

- **[Risco] Manter um changelog Liquibase único para H2 e MySQL pode exigir sintaxe compatível com ambos os bancos** → **Mitigação**: usar tipos e changesets genéricos do Liquibase (não SQL nativo específico de um banco) sempre que possível.
- **[Risco] Seed de 200 filmes reais exige pesquisa/curadoria de dados fora do código** → **Mitigação**: tratado como tarefa de implementação (`tasks.md`), não como decisão de design; dados reais podem ser compilados a partir de fontes públicas.
- **[Risco] Contexto de seed separado pode ser esquecido ao adicionar novos changesets no futuro, vazando dados de seed para os testes** → **Mitigação**: documentar a convenção no `AGENTS.md` deste repositório (todo changeset de dados, não de schema, deve usar o contexto `seed`).

## Open Questions

Nenhuma pendente para este repositório — todas as decisões relevantes foram fechadas na exploração.
