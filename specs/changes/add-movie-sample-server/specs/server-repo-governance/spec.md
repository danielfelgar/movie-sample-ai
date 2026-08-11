## ADDED Requirements

### Requirement: Repositório standalone
O repositório `movie-sample-server` SHALL poder ser aberto e trabalhado isoladamente pelo Claude Code, com seu próprio `AGENTS.md`, `CLAUDE.md` e pastas `.ai/{agents,skills}`, cujo conteúdo é linkado para `.claude/{agents,skills}` do próprio repositório.

#### Scenario: Repositório aberto isoladamente
- **WHEN** alguém clona apenas o `movie-sample-server` (sem os demais repositórios do workspace) e abre o Claude Code diretamente nele
- **THEN** o Claude Code encontra `AGENTS.md`/`CLAUDE.md` e as skills/agents customizados deste repositório, funcionando sem depender de `movie-sample-ai`

### Requirement: CLAUDE.md redireciona para AGENTS.md
O `movie-sample-server/CLAUDE.md` SHALL conter apenas um redirecionamento instruindo o leitor a consultar o `AGENTS.md` deste mesmo repositório.

#### Scenario: Claude Code lê o CLAUDE.md do movie-sample-server
- **WHEN** o Claude Code processa `movie-sample-server/CLAUDE.md`
- **THEN** é instruído a ler `movie-sample-server/AGENTS.md` para as convenções reais do projeto

### Requirement: AGENTS.md documenta as convenções específicas do server
O `movie-sample-server/AGENTS.md` SHALL documentar as convenções específicas deste repositório: stack de build (Gradle Groovy + TOML, Java 25, Spring Boot 4.1, MVC + JPA), a separação `api`/`core`, a convenção de manter o changelog do Liquibase compatível com H2 e MySQL, e a convenção de que novos changesets de dados (não de schema) devem usar o contexto `seed`.

#### Scenario: Leitor consulta as convenções do server
- **WHEN** alguém abre o `AGENTS.md` do `movie-sample-server`
- **THEN** encontra a stack de build, a separação de módulos, e as convenções de Liquibase (schema compatível com ambos os bancos, dados de seed em contexto separado)
