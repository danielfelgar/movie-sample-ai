## ADDED Requirements

### Requirement: Repositório standalone
O repositório `movie-sample-gateway` SHALL poder ser aberto e trabalhado isoladamente pelo Claude Code, com seu próprio `AGENTS.md`, `CLAUDE.md` e pastas `.ai/{agents,skills}`, cujo conteúdo é linkado para `.claude/{agents,skills}` do próprio repositório.

#### Scenario: Repositório aberto isoladamente
- **WHEN** alguém clona apenas o `movie-sample-gateway` (sem os demais repositórios do workspace) e abre o Claude Code diretamente nele
- **THEN** o Claude Code encontra `AGENTS.md`/`CLAUDE.md` e as skills/agents customizados deste repositório, funcionando sem depender de `movie-sample-ai`

### Requirement: CLAUDE.md redireciona para AGENTS.md
O `movie-sample-gateway/CLAUDE.md` SHALL conter apenas um redirecionamento instruindo o leitor a consultar o `AGENTS.md` deste mesmo repositório.

#### Scenario: Claude Code lê o CLAUDE.md do movie-sample-gateway
- **WHEN** o Claude Code processa `movie-sample-gateway/CLAUDE.md`
- **THEN** é instruído a ler `movie-sample-gateway/AGENTS.md` para as convenções reais do projeto

### Requirement: AGENTS.md documenta as convenções específicas do gateway
O `movie-sample-gateway/AGENTS.md` SHALL documentar as convenções específicas deste repositório: stack de build (Gradle Groovy + TOML, Java 25, Spring Boot 4.1, WebFlux), o papel do gateway como fachada única do sistema, e a convenção de manter a allowlist de rotas atualizada manualmente a cada nova página ou endpoint do sistema.

#### Scenario: Leitor consulta as convenções do gateway
- **WHEN** alguém abre o `AGENTS.md` do `movie-sample-gateway`
- **THEN** encontra a stack de build do repositório, o papel do gateway na arquitetura do workspace, e a convenção de atualização manual da allowlist de rotas
