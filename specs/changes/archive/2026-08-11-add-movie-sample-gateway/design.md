## Context

O `movie-sample-gateway` é o segundo repositório do workspace do catálogo de filmes a ser implementado. `movie-sample-server` e `movie-sample-front` ainda não existem como repositórios de código — o gateway é construído e testável de forma independente (roteamento pode ser verificado com destinos mockados ou stubs), consumindo apenas o contrato já publicado em `openspec/specs/movie-domain-spec` como referência de domínio (indiretamente, via os paths `/api/movies`), sem depender da implementação real do server ou do front existir.

Este repositório segue o padrão standalone já estabelecido no workspace: pode ser aberto e trabalhado isoladamente pelo Claude Code, com seu próprio `AGENTS.md`/`CLAUDE.md`/`.ai/{skills,agents}`.

## Goals / Non-Goals

**Goals:**
- Implementar a allowlist explícita de rotas definida na exploração: path completo + método para a API, path completo por página para o front, wildcard restrito a `/_next/**`.
- Tornar os hosts downstream configuráveis via variável de ambiente, sem exigir rebuild para trocar entre execução local e Docker Compose.
- Deixar o repositório pronto para standalone use (AGENTS.md, CLAUDE.md, `.ai/{skills,agents}`).
- Fornecer um Dockerfile que o `docker-compose.yml` do `movie-sample-ai` poderá referenciar.

**Non-Goals:**
- Implementar `movie-sample-server` ou `movie-sample-front` — são mudanças futuras separadas.
- Tratamento de CORS, autenticação, rate limiting ou qualquer filtro cross-cutting — fora do escopo deste projeto de artigo.
- Resiliência a falhas downstream (circuit breaker, retry, fallback) — usa o comportamento padrão do Spring Cloud Gateway.
- Testes de integração ponta a ponta contra o `server`/`front` reais (ainda não existem); testes deste repositório validam roteamento contra destinos de teste/stub.

## Decisions

### 1. Allowlist explícita por path completo + método, sem wildcard (exceto `/_next/**`)
Cada rota é declarada com predicates de `Path` e `Method` combinados, ao invés de um prefixo genérico (`/api/**`). Isso torna a configuração do gateway uma documentação viva da superfície pública do sistema — qualquer requisição fora da allowlist simplesmente não é roteada.

**Alternativa considerada:** prefixo `/api/**` para toda a API e `/**` para o front (mais simples de configurar, menos linhas). Rejeitada porque perde a propriedade de allowlist auditável, que foi uma decisão explícita da exploração.

**Exceção deliberada:** `/_next/**` precisa de wildcard porque os assets estáticos gerados pelo Next.js têm nomes com hash de build, impossíveis de enumerar antecipadamente.

### 2. WebFlux (reativo), não Spring MVC
O Spring Cloud Gateway roda nativamente sobre WebFlux/Netty. Mesmo que o `movie-sample-server` (mudança futura) use Spring MVC tradicional, o gateway sendo I/O-bound (só encaminha requisições) se beneficia do modelo reativo — e é o caminho de menor resistência com o Spring Cloud Gateway padrão (a variante MVC/servlet é mais recente e menos madura).

### 3. Hosts downstream via variável de ambiente com default localhost
`SERVER_URI` (default `http://localhost:8081`) e `FRONT_URI` (default `http://localhost:3000`) permitem rodar o gateway localmente sem Docker (usando os defaults) e via Docker Compose apenas sobrescrevendo essas variáveis com os nomes de serviço do compose (`http://server:8081`, `http://front:3000`) — zero mudança de código entre os dois ambientes.

### 4. Módulo único, sem separação `api`/`core`
Diferente do `movie-sample-server`, o gateway não tem lógica de domínio — é só configuração de roteamento. Um módulo Gradle único é suficiente e evita complexidade desnecessária.

## Risks / Trade-offs

- **[Risco] A allowlist explícita exige atualização manual sempre que uma nova página ou endpoint for adicionado ao sistema** → **Mitigação**: aceito conscientemente — é o trade-off pela auditabilidade; documentado no `AGENTS.md` deste repositório como convenção a seguir em mudanças futuras.
- **[Risco] Testar o roteamento sem o `server`/`front` reais existirem ainda** → **Mitigação**: testes deste repositório usam destinos de teste (ex: um servidor HTTP de stub ou `WireMock`) para verificar que cada rota direciona para o predicate correto, sem depender da implementação real.
- **[Risco] Comportamento padrão do Spring Cloud Gateway para downstream indisponível pode não ser amigável (erro genérico) já que não há tratamento de resiliência** → **Mitigação**: aceito conscientemente — fora do escopo deste projeto de artigo.

## Open Questions

Nenhuma pendente para este repositório — todas as decisões relevantes foram fechadas na exploração.
