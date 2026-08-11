# front-plugin-dependency

## Purpose

A dependência do `movie-sample-front` no plugin `frontend-design` do
marketplace `anthropics/claude-code`, declarada localmente no repositório
e agregada pelo `init-workspace.sh` quando o `movie-sample-front` está
presente no workspace completo.

## Requirements

### Requirement: Declaração do plugin frontend-design

O repositório `movie-sample-front` SHALL declarar, em seu próprio
`.claude/settings.json`, o plugin `frontend-design` do marketplace
`anthropics/claude-code` via `enabledPlugins`/`extraKnownMarketplaces`.

#### Scenario: Repositório aberto isoladamente

- **WHEN** alguém abre o Claude Code diretamente dentro do
  `movie-sample-front`, sem o restante do workspace
- **THEN** o plugin `frontend-design` está declarado no
  `.claude/settings.json` local, disponível para ativação nesse contexto

#### Scenario: Workspace completo montado

- **WHEN** o `init-workspace.sh` do `movie-sample-ai` é executado com o
  `movie-sample-front` presente no workspace
- **THEN** a declaração deste `.claude/settings.json` é agregada ao
  `.claude/settings.json` da raiz do workspace, conforme já implementado
  em `workspace-init-script`
