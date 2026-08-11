## ADDED Requirements

### Requirement: Repositório standalone
O repositório `movie-sample-front` SHALL poder ser aberto e trabalhado isoladamente pelo Claude Code, com seu próprio `AGENTS.md`, `CLAUDE.md` e pastas `.ai/{agents,skills}`, cujo conteúdo é linkado para `.claude/{agents,skills}` do próprio repositório.

#### Scenario: Repositório aberto isoladamente
- **WHEN** alguém clona apenas o `movie-sample-front` (sem os demais repositórios do workspace) e abre o Claude Code diretamente nele
- **THEN** o Claude Code encontra `AGENTS.md`/`CLAUDE.md` e as skills/agents customizados deste repositório, funcionando sem depender de `movie-sample-ai`

### Requirement: CLAUDE.md redireciona para AGENTS.md
O `movie-sample-front/CLAUDE.md` SHALL conter apenas um redirecionamento instruindo o leitor a consultar o `AGENTS.md` deste mesmo repositório.

#### Scenario: Claude Code lê o CLAUDE.md do movie-sample-front
- **WHEN** o Claude Code processa `movie-sample-front/CLAUDE.md`
- **THEN** é instruído a ler `movie-sample-front/AGENTS.md` para as convenções reais do projeto

### Requirement: AGENTS.md documenta as convenções específicas do front
O `movie-sample-front/AGENTS.md` SHALL documentar as convenções específicas deste repositório: stack (Next.js App Router, npm, Tailwind CSS), a regra de sempre se comunicar com a API através do gateway, o uso de Server Actions para mutações, e a convenção de manter a validação Zod sincronizada com `movie-domain-spec`.

#### Scenario: Leitor consulta as convenções do front
- **WHEN** alguém abre o `AGENTS.md` do `movie-sample-front`
- **THEN** encontra a stack do repositório, a regra de comunicação sempre via gateway, e a convenção de manter a validação Zod sincronizada com o contrato de domínio
