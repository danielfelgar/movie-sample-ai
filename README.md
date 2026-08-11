# movie-sample-ai

Repositório central do workspace do **catálogo de filmes** — um projeto de exemplo
para um artigo sobre como organizar múltiplos repositórios usando `AGENTS.md` como
single source of truth e Spec-Driven Development (SDD) via [OpenSpec](https://github.com/Fission-AI/OpenSpec).

Este repositório não contém código de aplicação. Ele concentra:
- As specs do domínio e do workspace (`specs/`)
- Skills e agents customizados do Claude Code (`.ai/`)
- O script que conecta tudo isso ao restante do workspace (`scripts/init-workspace.sh`)
- O `AGENTS.md` com as convenções gerais do workspace

## Catálogo de repositórios

| Repositório              | Descrição                                                                 |
|---------------------------|----------------------------------------------------------------------------|
| `movie-sample-ai`          | Este repositório — specs, skills, agents e `AGENTS.md`, fonte única de verdade do workspace |
| `movie-sample-gateway`      | Spring Cloud Gateway — fachada única de roteamento (`/api/**` → backend, demais rotas → front) |
| `movie-sample-server`       | API Spring (multi-módulo `api`/`core`) — cadastro de filmes                |
| `movie-sample-front`         | Aplicação Next.js — interface gráfica do catálogo                          |

## Como montar o workspace

1. Crie uma pasta local para servir de raiz do workspace (não precisa ser um
   repositório git — na verdade, não deve ser).
2. Clone os repositórios que você for usar lado a lado dentro dela:
   ```
   git clone <url>/movie-sample-ai.git
   git clone <url>/movie-sample-gateway.git
   git clone <url>/movie-sample-server.git
   git clone <url>/movie-sample-front.git
   ```
3. Rode o script de inicialização:
   ```
   ./movie-sample-ai/scripts/init-workspace.sh
   ```
4. Abra o Claude Code a partir da raiz do workspace (não de dentro de um subprojeto).

Isso deixa o workspace pronto: OpenSpec inicializado na raiz, skills/agents
customizados disponíveis, e plugins declarados pelos subprojetos habilitados.

## Por que a estrutura é assim

Cada subprojeto do workspace é standalone — pode ser aberto sozinho no Claude Code e
continua funcionando, com seu próprio `AGENTS.md` e suas próprias skills/agents. O
`movie-sample-ai` existe para dar a esses repositórios independentes uma fonte comum
de convenções e um contrato de domínio compartilhado, sem duplicar conteúdo entre eles.

Para entender as convenções do workspace em detalhe, veja [`AGENTS.md`](./AGENTS.md).
