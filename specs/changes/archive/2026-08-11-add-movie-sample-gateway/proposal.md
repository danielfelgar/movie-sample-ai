## Why

Com o `movie-sample-ai` implementado, o próximo passo é o `movie-sample-gateway` — a fachada única do sistema, por onde toda requisição externa (humana ou de API) passa antes de chegar no backend (`movie-sample-server`) ou no frontend (`movie-sample-front`). Sem ele, não há um ponto único de entrada nem uma allowlist explícita de rotas, o que é central para a arquitetura do workspace já decidida na exploração.

## What Changes

- Criar o repositório `movie-sample-gateway`: Spring Cloud Gateway reativo (WebFlux), Gradle Groovy DSL + catálogo de versões TOML, Java 25, Spring Boot 4.1.0, módulo único.
- Definir uma allowlist explícita de rotas — path completo + método HTTP para a API (`/api/movies`, `/api/movies/{id}`), e path completo por página para o front (`/`, `/movies`, `/movies/{id}`, `/movies/new`), com wildcard reservado apenas para os assets estáticos do Next.js (`/_next/**`). Nenhuma outra rota é permitida.
- Tornar os hosts de destino (`movie-sample-server`, `movie-sample-front`) configuráveis via variável de ambiente com default `localhost`, sem exigir mudança de código entre execução local e via Docker Compose.
- Expor Actuator health (`/actuator/health`) e rodar na porta 8080.
- Adicionar Dockerfile próprio, para ser referenciado pelo `docker-compose.yml` já existente em `movie-sample-ai`.
- Criar a estrutura standalone do repositório (`AGENTS.md`, `CLAUDE.md`, `.ai/{skills,agents}` com symlinks auto-referenciados), seguindo o mesmo padrão dos demais subprojetos do workspace.

## Capabilities

### New Capabilities
- `gateway-routing`: a allowlist explícita de rotas do gateway — path completo + método HTTP para a API, path completo por página para o front, wildcard restrito aos assets do Next.js, e ausência de qualquer outra rota.
- `gateway-operations`: configuração operacional do gateway — hosts de destino configuráveis via variável de ambiente com default localhost, Actuator health, porta 8080, comportamento padrão do Spring Cloud Gateway para falhas downstream, e Dockerfile próprio.
- `gateway-repo-governance`: estrutura standalone do repositório `movie-sample-gateway` — `AGENTS.md`/`CLAUDE.md` próprios e `.ai/{skills,agents}` symlinkados para uso standalone, consistente com o padrão dos demais subprojetos do workspace.

### Modified Capabilities
(nenhuma — nenhuma spec existente muda de comportamento; `workspace-docker-compose` continua válida como está, só terá seu placeholder de `build.context` preenchido futuramente na implementação, o que não é uma mudança de requisito)

## Impact

- Novo repositório `movie-sample-gateway`, criado como pasta irmã de `movie-sample-ai` no workspace.
- Nenhuma mudança em `movie-sample-ai`, `movie-sample-server` ou `movie-sample-front` — este repositório consome o contrato já definido (`movie-domain-spec`), mas não implementa `server` nem `front` (escopo de mudanças futuras).
- Nenhuma mudança de requisito em specs existentes do workspace.
