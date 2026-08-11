## ADDED Requirements

### Requirement: Instalação e inicialização do OpenSpec na raiz do workspace
O `scripts/init-workspace.sh` SHALL instalar e inicializar o OpenSpec para o Claude Code na raiz do workspace (`workspace`) quando executado.

#### Scenario: Execução em workspace sem OpenSpec inicializado
- **WHEN** o script é executado a partir da raiz do `workspace` e o OpenSpec ainda não está instalado/inicializado ali
- **THEN** o script instala e inicializa o OpenSpec na raiz do `workspace`

### Requirement: Symlink de specs para a raiz do workspace
O script SHALL criar um symlink `workspace/openspec` apontando para `movie-sample-ai/specs`.

#### Scenario: Criação do symlink de specs
- **WHEN** o script é executado e `movie-sample-ai/specs` existe
- **THEN** `workspace/openspec` passa a existir como symlink para `movie-sample-ai/specs`

### Requirement: Symlinks de skills e agents para a raiz do workspace
O script SHALL criar os symlinks `workspace/.claude/skills` → `movie-sample-ai/.ai/skills` e `workspace/.claude/agents` → `movie-sample-ai/.ai/agents`.

#### Scenario: Criação dos symlinks de skills e agents
- **WHEN** o script é executado e `movie-sample-ai/.ai/skills` e `movie-sample-ai/.ai/agents` existem
- **THEN** `workspace/.claude/skills` e `workspace/.claude/agents` passam a existir como symlinks para essas pastas

### Requirement: Geração dos stubs CLAUDE.md e AGENTS.md na raiz do workspace
O script SHALL gerar (como arquivos reais, não symlinks) `workspace/CLAUDE.md` e `workspace/AGENTS.md`, cada um redirecionando o leitor para `movie-sample-ai/AGENTS.md` e informando explicitamente que o arquivo é gerado automaticamente e não deve ser editado manualmente nem por agentes.

#### Scenario: Geração dos stubs na raiz
- **WHEN** o script é executado a partir da raiz do `workspace`
- **THEN** `workspace/CLAUDE.md` e `workspace/AGENTS.md` são criados (ou sobrescritos) como arquivos contendo o redirecionamento para `movie-sample-ai/AGENTS.md` e o aviso de não edição manual

### Requirement: Agregação de configuração de plugins na raiz do workspace
O script SHALL ler o `.claude/settings.json` de cada subprojeto presente no workspace (`movie-sample-gateway`, `movie-sample-server`, `movie-sample-front`) e agregar os campos `enabledPlugins` e `extraKnownMarketplaces` declarados neles em um `.claude/settings.json` gerado em `workspace/.claude/settings.json`.

#### Scenario: Subprojeto declara um plugin
- **WHEN** um subprojeto presente no workspace possui `.claude/settings.json` com `enabledPlugins`/`extraKnownMarketplaces`
- **THEN** esses valores são incluídos no `.claude/settings.json` gerado na raiz do workspace

#### Scenario: Subprojeto ausente ou sem settings.json
- **WHEN** um subprojeto esperado não existe no `workspace`, ou existe mas não possui `.claude/settings.json`
- **THEN** o script não trata isso como erro e simplesmente não agrega nada daquele subprojeto

### Requirement: Sem clonagem de repositórios nem manifesto de repositórios
O script SHALL NOT clonar repositórios remotos e SHALL NOT ler ou manter um arquivo de manifesto (JSON/YAML) listando os repositórios do workspace.

#### Scenario: Execução sem acesso à internet ou a um manifesto
- **WHEN** o script é executado assumindo que os repositórios do workspace já foram clonados manualmente lado a lado
- **THEN** o script completa sua execução sem tentar clonar nenhum repositório nem depender de um arquivo de manifesto
