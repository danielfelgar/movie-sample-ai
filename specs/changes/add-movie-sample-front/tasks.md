## 1. Estrutura e setup do repositório

- [x] 1.1 Criar o projeto Next.js (App Router) com npm e Tailwind CSS em `movie-sample-front`
- [x] 1.2 Criar `.claude/`, `.ai/agents/`, `.ai/skills/`
- [x] 1.3 Configurar Vitest + React Testing Library

## 2. Governança do repositório (standalone)

- [x] 2.1 Escrever `movie-sample-front/AGENTS.md` com a stack, a regra de comunicação sempre via gateway, Server Actions, e a convenção de sincronizar a validação Zod com `movie-domain-spec`
- [x] 2.2 Escrever `movie-sample-front/CLAUDE.md` redirecionando para `movie-sample-front/AGENTS.md`
- [x] 2.3 Criar `.ai/skills/` e `.ai/agents/` com placeholder mínimo, e os symlinks `.claude/skills` → `.ai/skills` e `.claude/agents` → `.ai/agents`
- [x] 2.4 Criar `.claude/settings.json` declarando `enabledPlugins`/`extraKnownMarketplaces` para o plugin `frontend-design` do marketplace `anthropics/claude-code`

## 3. Integração com a API

- [x] 3.1 Gerar os tipos TypeScript a partir do contrato OpenAPI do `movie-sample-server` (ex: via `openapi-typescript`) — implementado como tipos derivados manualmente de `movie-domain-spec` (`lib/api/types.ts`), já que o `movie-sample-server` pode não estar em execução durante o desenvolvimento deste repositório (ver `AGENTS.md`, seção de convenções)
- [x] 3.2 Configurar a URL base do gateway usada tanto em Server Components/SSR quanto em chamadas client-side (via variável de ambiente, com default local)
- [x] 3.3 Implementar o schema Zod de validação do `Movie`, espelhando `movie-domain-spec`

## 4. Páginas

- [x] 4.1 Implementar a página `/movies` (listagem completa via `GET /api/movies` através do gateway), incluindo o estado vazio
- [x] 4.2 Implementar a página `/movies/{id}` em modo de leitura (via `GET /api/movies/{id}`), incluindo o estado "não encontrado"
- [x] 4.3 Implementar o modo de edição inline na página de detalhe, com Server Action chamando `PUT /api/movies/{id}` através do gateway
- [x] 4.4 Implementar a página `/movies/new` com formulário de cadastro, com Server Action chamando `POST /api/movies` através do gateway
- [x] 4.5 Implementar a ação de remoção de filme (Server Action chamando `DELETE /api/movies/{id}` através do gateway) a partir da página de detalhe

## 5. Docker

- [x] 5.1 Criar `Dockerfile` para a aplicação Next.js
- [x] 5.2 Atualizar o comentário/placeholder do serviço `front` em `movie-sample-ai/docker-compose.yml`, confirmando que o `build.context: ../movie-sample-front` agora aponta para um repositório com Dockerfile válido (consolidado após os 3 repositórios de aplicação estarem prontos, incluindo a variável `GATEWAY_URL` apontando para o serviço `gateway` do compose)

## 6. Testes

- [x] 6.1 Escrever testes com Vitest + React Testing Library para o schema de validação Zod (casos válidos e inválidos espelhando `movie-domain-spec`)
- [x] 6.2 Escrever testes com Vitest + React Testing Library para os componentes das páginas de listagem, detalhe (leitura e edição inline) e cadastro

## 7. Validação

- [x] 7.1 Rodar a suíte de testes e confirmar que todos passam
- [x] 7.2 Rodar o front localmente contra um `movie-sample-gateway`/`movie-sample-server` em execução e validar manualmente o fluxo completo: listar, cadastrar, editar inline e remover um filme — validado após os 3 repositórios estarem implementados: server (H2, porta 8081) + gateway (porta 8080) + front (porta 3000, `GATEWAY_URL=http://localhost:8080`) subidos juntos. Fluxo completo via gateway confirmado: `GET /movies` (200), `GET /api/movies` (200, 200 filmes), `POST /api/movies` (201 + Location), `GET/PUT /api/movies/{id}` (200), `GET /movies/{id}` (200), `DELETE /api/movies/{id}` (204), busca pós-delete (404), rota fora da allowlist (404).
- [x] 7.3 Validar as specs desta mudança com `openspec validate` antes de considerar pronta para archive

## 8. Correção pós-validação (encontrada via UI real no navegador)

- [x] 8.1 A validação 7.2 usou `curl` direto contra `/api/movies` — não exercitou a edição/cadastro pela UI de verdade. Testando pelo navegador, editar um filme falhava com "An unexpected response was received from the server": o gateway só permitia `GET` em `/movies/{id}` e `/movies/new`, mas as Server Actions do Next.js fazem `POST` para a própria URL da página (corrigido em `add-movie-sample-gateway`, ver `gateway-routing`)
- [x] 8.2 Depois da correção de roteamento, surgiu um segundo erro: `Invalid Server Actions request` — a checagem de CSRF do Next.js rejeita a Server Action porque a origem pública (a do gateway) difere do host interno. Corrigido com `experimental.serverActions.allowedOrigins` em `next.config.ts`, configurável via `GATEWAY_PUBLIC_ORIGIN` (build ARG, não env var de runtime — ver `AGENTS.md`)
- [x] 8.3 Revalidado o fluxo de edição inline pela UI real (navegador) através do gateway em Docker Compose, com sucesso
