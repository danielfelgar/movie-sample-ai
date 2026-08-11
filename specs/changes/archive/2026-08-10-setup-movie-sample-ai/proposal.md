## Why

O catálogo de filmes será construído como 4 repositórios independentes (`movie-sample-ai`, `movie-sample-gateway`, `movie-sample-server`, `movie-sample-front`) organizados como pastas irmãs dentro de um workspace local. Sem um repositório central que concentre specs, skills, agents e convenções, cada repositório de aplicação não teria uma fonte única de verdade para consultar, e não existiria um jeito reproduzível de montar o workspace local do zero. Este é também o artefato central de um artigo sobre como organizar múltiplos repositórios usando `AGENTS.md` como single source of truth e Spec-Driven Development via OpenSpec — por isso a clareza pedagógica da estrutura importa tanto quanto a funcionalidade.

## What Changes

- Criar a estrutura de pastas do repositório `movie-sample-ai` (`.claude/`, `.ai/{agents,skills}`, `specs/{specs,changes}`, `scripts/`, `AGENTS.md`, `CLAUDE.md`, `README.md`).
- Adicionar o script `scripts/init-workspace.sh`, responsável por: instalar/inicializar o OpenSpec na raiz do workspace; criar os symlinks de specs/skills/agents da raiz do workspace para este repositório; gerar (não symlinkar) `CLAUDE.md`/`AGENTS.md` na raiz do workspace como stubs de redirecionamento somente-leitura; e agregar os `enabledPlugins`/`extraKnownMarketplaces` declarados no `.claude/settings.json` de cada subprojeto dentro de um `.claude/settings.json` gerado na raiz do workspace.
- Escrever `AGENTS.md` (fonte única de verdade sobre convenções gerais e cross-cutting do workspace) e `README.md`, ambos incluindo um catálogo dos repositórios do workspace e o passo a passo de montagem do workspace.
- Definir a spec do domínio `Movie` (campos, tipos, regras de validação) como contrato compartilhado entre `movie-sample-server` e `movie-sample-front`, a ser implementado em mudanças futuras desses repositórios.
- Adicionar um `docker-compose.yml` unificado, versionado neste repositório, preparado para subir os 4 serviços (gateway, server, front, banco de dados) quando os demais repositórios existirem.

## Capabilities

### New Capabilities
- `workspace-init-script`: comportamento do `scripts/init-workspace.sh` — instalação/inicialização do OpenSpec, criação de symlinks, geração dos stubs `CLAUDE.md`/`AGENTS.md` na raiz, e agregação de configuração de plugins na raiz do workspace.
- `workspace-governance-docs`: estrutura e conteúdo obrigatório do `AGENTS.md` e `README.md` do `movie-sample-ai` — catálogo de repositórios, passo a passo de setup, e a regra de divisão entre informação geral (aqui) e informação específica (em cada subprojeto).
- `movie-domain-spec`: o contrato compartilhado do domínio `Movie` (campos, tipos, regras de validação) usado como fonte única de verdade pelos repositórios `movie-sample-server` e `movie-sample-front`.
- `workspace-docker-compose`: o `docker-compose.yml` unificado, versionado no `movie-sample-ai`, para orquestrar os 4 serviços do workspace.

### Modified Capabilities
(nenhuma — repositório e specs greenfield)

## Impact

- Novo repositório `movie-sample-ai`: estrutura de pastas, script de bootstrap, documentação de governança, spec de domínio, docker-compose.
- Nenhuma mudança de código nos repositórios `movie-sample-gateway`, `movie-sample-server` ou `movie-sample-front` — eles ainda não existem como repositórios implementados; a spec `movie-domain-spec` criada aqui será a base para mudanças futuras que os implementem.
- Estabelece o contrato de dados do `Movie` que qualquer implementação futura de `server`/`front` deve seguir.
