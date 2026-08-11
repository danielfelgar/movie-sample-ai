## 1. Estrutura e build do repositório

- [x] 1.1 Criar a estrutura de diretórios do repositório `movie-sample-server` com os módulos `api` e `core`
- [x] 1.2 Configurar `build.gradle` (Groovy DSL, raiz e por módulo) e `gradle/libs.versions.toml` com Java 25, Spring Boot 4.1.0, Spring Web (MVC), Spring Data JPA, Liquibase, springdoc-openapi, Actuator
- [x] 1.3 Configurar `settings.gradle` incluindo os módulos `api` e `core`, com `api` dependendo de `core`

## 2. Governança do repositório (standalone)

- [x] 2.1 Escrever `movie-sample-server/AGENTS.md` com a stack de build, a separação `api`/`core`, e as convenções de Liquibase (schema compatível H2/MySQL, contexto `seed` para dados)
- [x] 2.2 Escrever `movie-sample-server/CLAUDE.md` redirecionando para `movie-sample-server/AGENTS.md`
- [x] 2.3 Criar `.ai/skills/` e `.ai/agents/` com placeholder mínimo, e os symlinks `.claude/skills` → `.ai/skills` e `.claude/agents` → `.ai/agents`

## 3. Domínio e persistência (módulo core)

- [x] 3.1 Implementar a entidade `Movie` no módulo `core` conforme `movie-domain-spec`: `id` (Long, PK autoincrement), `uuid` (gerado na criação), `titulo`, `ano`, `genero`, `diretor`, `sinopse` (TEXT), `duracao`
- [x] 3.2 Implementar o repositório Spring Data JPA de `Movie`
- [x] 3.3 Criar o changelog do Liquibase com o schema de `Movie`, compatível com H2 e MySQL
- [x] 3.4 Configurar o perfil de desenvolvimento (H2) e o perfil docker (MySQL), ambos aplicando o mesmo changelog

## 4. Seed de dados

- [x] 4.1 Levantar dados reais de 200 filmes (título, ano, gênero, diretor, sinopse, duração) a partir de fontes públicas
- [x] 4.2 Criar changeset(s) do Liquibase inserindo os 200 filmes, usando o contexto `seed`
- [x] 4.3 Configurar os perfis de desenvolvimento e docker para ativar o contexto `seed`, e o perfil de teste para NÃO ativá-lo

## 5. API REST (módulo api)

- [x] 5.1 Implementar os DTOs de request/response de `Movie`, com validação Bean Validation espelhando `movie-domain-spec`
- [x] 5.2 Implementar o controller com `POST /api/movies` (201 + Location) e `GET /api/movies` (200, lista completa)
- [x] 5.3 Implementar o controller com `GET /api/movies/{id}` (200 ou 404)
- [x] 5.4 Implementar `PUT /api/movies/{id}` (200 com recurso atualizado, ou 404)
- [x] 5.5 Implementar `DELETE /api/movies/{id}` (204, ou 404)
- [x] 5.6 Implementar o exception handling usando `ProblemDetail` para erros de validação e de recurso não encontrado

## 6. Operação

- [x] 6.1 Configurar springdoc-openapi para expor a documentação da API
- [x] 6.2 Habilitar Spring Boot Actuator expondo `/actuator/health`
- [x] 6.3 Criar `Dockerfile` multi-stage (build via Gradle, runtime em imagem leve)
- [x] 6.4 Atualizar o comentário/placeholder do serviço `server` em `movie-sample-ai/docker-compose.yml`, confirmando que o `build.context: ../movie-sample-server` agora aponta para um repositório com Dockerfile válido (consolidado após os 3 repositórios de aplicação estarem prontos, para evitar edição concorrente do arquivo compartilhado por agentes em paralelo)

## 7. Testes

- [x] 7.1 Escrever testes REST Assured contra H2 cobrindo os cenários de `server-movie-api` (criação válida/inválida, listagem vazia/com itens, busca por id existente/inexistente, atualização válida/inválida/inexistente, remoção existente/inexistente)
- [x] 7.2 Confirmar que os testes rodam com o contexto `seed` do Liquibase desativado e a base de teste começa vazia (exceto schema)

## 8. Validação

- [x] 8.1 Rodar a suíte de testes e confirmar que todos passam
- [x] 8.2 Subir a aplicação localmente com H2 e confirmar visualmente que os 200 filmes de seed aparecem em `GET /api/movies`
- [x] 8.3 Validar as specs desta mudança com `openspec validate` antes de considerar pronta para archive
