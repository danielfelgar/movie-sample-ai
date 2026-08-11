## ADDED Requirements

### Requirement: Catálogo de repositórios do workspace
O `AGENTS.md` e o `README.md` do `movie-sample-ai` SHALL conter uma seção de catálogo de repositórios, listando cada repositório do workspace (`movie-sample-ai`, `movie-sample-gateway`, `movie-sample-server`, `movie-sample-front`) com uma descrição curta do que ele faz. Essa seção SHALL ser mantida manualmente, sem ser gerada a partir de um arquivo de configuração.

#### Scenario: Leitor consulta o catálogo de repositórios
- **WHEN** alguém abre o `AGENTS.md` ou o `README.md` do `movie-sample-ai`
- **THEN** encontra uma tabela ou lista com os 4 repositórios do workspace e uma descrição curta de cada um

### Requirement: Passo a passo de montagem do workspace
O `AGENTS.md` e o `README.md` SHALL conter instruções passo a passo de como montar o workspace localmente: clonar os 4 repositórios lado a lado dentro de uma pasta comum e executar `movie-sample-ai/scripts/init-workspace.sh`.

#### Scenario: Novo colaborador monta o workspace pela primeira vez
- **WHEN** um novo colaborador segue as instruções do `README.md`
- **THEN** consegue clonar os 4 repositórios lado a lado e executar o `init-workspace.sh` sem precisar de informação adicional

### Requirement: Documentação da fronteira entre informação geral e específica
O `AGENTS.md` do `movie-sample-ai` SHALL documentar explicitamente a regra de que informação geral/cross-cutting do workspace (convenções compartilhadas, modelo de domínio `Movie`) mora neste repositório, enquanto informação específica de cada subprojeto mora no `AGENTS.md` daquele subprojeto.

#### Scenario: Leitor decide onde documentar uma nova convenção
- **WHEN** alguém precisa decidir se uma nova convenção é cross-cutting ou específica de um subprojeto
- **THEN** o `AGENTS.md` do `movie-sample-ai` fornece o critério para essa decisão

### Requirement: CLAUDE.md redireciona para AGENTS.md
O `movie-sample-ai/CLAUDE.md` SHALL conter apenas um redirecionamento instruindo o leitor a consultar o `AGENTS.md` deste mesmo repositório.

#### Scenario: Claude Code lê o CLAUDE.md do movie-sample-ai
- **WHEN** o Claude Code processa `movie-sample-ai/CLAUDE.md`
- **THEN** é instruído a ler `movie-sample-ai/AGENTS.md` para as convenções reais do projeto
