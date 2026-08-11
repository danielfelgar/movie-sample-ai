## Why

O `movie-sample-front` é a interface gráfica do catálogo — sem ele, o `movie-sample-server` e o `movie-sample-gateway` não têm consumidor humano, e o workspace fica sem a peça que efetivamente permite cadastrar e visualizar filmes através de uma UI.

## What Changes

- Criar o repositório `movie-sample-front`: aplicação Next.js (App Router), npm como gerenciador de pacotes, Tailwind CSS.
- Implementar as páginas do catálogo: listagem (`/movies`), detalhe com edição inline (`/movies/{id}`), e cadastro (`/movies/new`), todas consumindo a API sempre através do `movie-sample-gateway` (mesma origem, inclusive em Server Components/SSR).
- Implementar as mutações (criar, atualizar, remover filme) via Server Actions.
- Gerar tipos TypeScript a partir do contrato OpenAPI do `movie-sample-server`.
- Validar os formulários no client com Zod, espelhando as mesmas regras de `movie-domain-spec`.
- Declarar a dependência do plugin `frontend-design` (marketplace `anthropics/claude-code`) no `.claude/settings.json` deste repositório.
- Adicionar testes leves (Vitest + React Testing Library) e Dockerfile próprio.
- Criar a estrutura standalone do repositório (`AGENTS.md`, `CLAUDE.md`, `.ai/{skills,agents}`), seguindo o mesmo padrão dos demais subprojetos do workspace.

## Capabilities

### New Capabilities
- `front-movie-pages`: as páginas de listagem, detalhe (com edição inline) e cadastro de filmes, consumindo a API sempre através do gateway, com mutações via Server Actions e validação client-side via Zod espelhando `movie-domain-spec`.
- `front-plugin-dependency`: a declaração do plugin `frontend-design` no `.claude/settings.json` deste repositório, para geração de UI com boa qualidade estética.
- `front-repo-governance`: estrutura standalone do repositório `movie-sample-front` — `AGENTS.md`/`CLAUDE.md` próprios e `.ai/{skills,agents}` symlinkados, consistente com o padrão dos demais subprojetos do workspace.

### Modified Capabilities
(nenhuma — nenhuma spec existente muda de comportamento; este repositório consome o contrato já definido em `movie-domain-spec` e as rotas já definidas em `gateway-routing`, sem alterá-los)

## Impact

- Novo repositório `movie-sample-front`, criado como pasta irmã dos demais no workspace.
- Torna o workspace funcionalmente completo do ponto de vista de uso: com `movie-sample-ai`, `movie-sample-gateway`, `movie-sample-server` e `movie-sample-front` implementados, o catálogo de filmes pode ser usado de ponta a ponta.
- Depende de `movie-sample-gateway` (rotas já definidas em `gateway-routing`) e `movie-sample-server` (contrato de API já definido em `server-movie-api`) existirem para funcionar em tempo de execução, mas seu código pode ser desenvolvido e testado (Vitest/RTL) de forma independente.
