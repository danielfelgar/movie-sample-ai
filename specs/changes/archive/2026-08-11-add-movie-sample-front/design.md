## Context

O `movie-sample-front` é o último dos 4 repositórios do workspace a ser implementado, depois de `movie-sample-ai`, `movie-sample-gateway` e `movie-sample-server`. Ele consome o contrato de domínio (`movie-domain-spec`) e a API real do `movie-sample-server` (`server-movie-api`) através das rotas já definidas no `movie-sample-gateway` (`gateway-routing`). Este repositório também depende do plugin `frontend-design` (`anthropics/claude-code`) para geração de UI, cuja mecânica de ativação em nível de workspace já foi resolvida na mudança `setup-movie-sample-ai` (agregação de `.claude/settings.json` pelo `init-workspace.sh`).

## Goals / Non-Goals

**Goals:**
- Implementar as 3 páginas do catálogo (listagem, detalhe com edição inline, cadastro) consumindo a API sempre através do gateway, inclusive em SSR/Server Components.
- Usar Server Actions para as mutações, evitando fetch manual no client.
- Validar formulários com Zod espelhando as regras de `movie-domain-spec`, dando feedback antes do submit.
- Gerar tipos TypeScript a partir do OpenAPI do server, mantendo o contrato como fonte única também no front.
- Declarar a dependência do plugin `frontend-design` corretamente para que funcione quando o workspace completo é montado.

**Non-Goals:**
- Paginação na listagem — segue a decisão do server de listagem completa por ora.
- Testes end-to-end (Playwright ou similar) — os testes deste repositório são leves (Vitest + React Testing Library).
- Qualquer bypass direto ao `movie-sample-server` — toda comunicação, mesmo em SSR, passa pelo gateway.
- Autenticação de usuário — fora do escopo deste projeto de artigo.

## Decisions

### 1. Sempre via gateway, mesmo em SSR (Opção A da exploração)
Tanto o fetch em Server Components (SSR) quanto qualquer chamada client-side usam a URL do gateway como base — nunca o endereço do server diretamente. Isso mantém o gateway como o único ponto de verdade sobre roteamento, evitando que o front precise conhecer dois endereços diferentes do server (um para SSR, outro para o browser).

**Alternativa considerada:** bypassar o gateway em SSR, falando direto com o server (mais eficiente, evita um hop de rede). Rejeitada pela exploração em favor da simplicidade da história arquitetural do artigo.

### 2. Edição inline, sem rota separada
A página de detalhe (`/movies/{id}`) inclui um botão "editar" que habilita os campos para edição no lugar, sem navegar para uma rota `/movies/{id}/edit`. Isso mantém a allowlist de rotas do gateway (`gateway-routing`) inalterada — só as 4 páginas já definidas.

### 3. Server Actions para mutações
Criar, atualizar e remover filme são implementados como Server Actions do Next.js, chamando a API do gateway a partir do servidor Next.js. Evita boilerplate de fetch manual e state de loading/erro no client para essas operações.

### 4. Zod espelhando movie-domain-spec
As mesmas regras de validação do backend (`titulo` obrigatório até 255 caracteres, `ano` entre 1888 e ano atual + 10, `genero`/`diretor` obrigatórios, `sinopse` opcional, `duracao` entre 1 e 999) são replicadas em um schema Zod usado nos formulários de cadastro e edição, dando feedback imediato ao usuário antes de qualquer round-trip ao servidor.

### 5. Declaração do plugin frontend-design em .claude/settings.json
Conforme decidido em `setup-movie-sample-ai`, este repositório declara `enabledPlugins`/`extraKnownMarketplaces` no seu próprio `.claude/settings.json` (fonte de verdade local e caso de uso standalone). A ativação efetiva no fluxo principal do workspace depende da agregação feita pelo `init-workspace.sh` — não é responsabilidade desta mudança reimplementar essa agregação, já implementada em `movie-sample-ai`.

## Risks / Trade-offs

- **[Risco] Sempre passar pelo gateway em SSR adiciona um hop de rede extra em cada renderização de página** → **Mitigação**: aceito conscientemente — trade-off pela simplicidade arquitetural, adequado ao escopo de um projeto de artigo.
- **[Risco] Duplicar regras de validação (Zod no front, Bean Validation no server) pode divergir ao longo do tempo** → **Mitigação**: ambas as implementações devem referenciar `movie-domain-spec` como fonte única; qualquer mudança de regra precisa atualizar a spec primeiro, depois as duas implementações.
- **[Risco] O plugin `frontend-design` não ter efeito se alguém abrir apenas o `movie-sample-front` sem rodar `init-workspace.sh` no workspace completo** → **Mitigação**: aceito — nesse caso, o `.claude/settings.json` local do próprio repositório já habilita o plugin para o uso standalone, funcionando igual.

## Open Questions

Nenhuma pendente para este repositório — todas as decisões relevantes foram fechadas na exploração.
