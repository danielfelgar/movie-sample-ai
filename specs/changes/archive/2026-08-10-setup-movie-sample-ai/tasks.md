## 1. Estrutura de pastas do movie-sample-ai

- [x] 1.1 Criar a estrutura de diretórios do repositório `movie-sample-ai`: `.claude/`, `.ai/agents/`, `.ai/skills/`, `specs/specs/`, `specs/changes/`, `scripts/`
- [x] 1.2 Criar os arquivos vazios/placeholder necessários para os diretórios não ficarem vazios no controle de versão (ex.: `.gitkeep` ou um exemplo mínimo em `.ai/skills/`)

## 2. Script init-workspace.sh

- [x] 2.1 Implementar a etapa de instalação/inicialização do OpenSpec na raiz do `workspace`
- [x] 2.2 Implementar a criação do symlink `workspace/openspec` → `movie-sample-ai/specs`
- [x] 2.3 Implementar a criação dos symlinks `workspace/.claude/skills` → `movie-sample-ai/.ai/skills` e `workspace/.claude/agents` → `movie-sample-ai/.ai/agents`
- [x] 2.4 Implementar a geração dos stubs `workspace/CLAUDE.md` e `workspace/AGENTS.md`, com redirecionamento para `movie-sample-ai/AGENTS.md` e aviso de "gerado automaticamente, não editar"
- [x] 2.5 Implementar a leitura do `.claude/settings.json` de cada subprojeto presente (`movie-sample-gateway`, `movie-sample-server`, `movie-sample-front`) e a agregação de `enabledPlugins`/`extraKnownMarketplaces` no `workspace/.claude/settings.json` gerado
- [x] 2.6 Tratar como caso normal (sem erro) a ausência de um subprojeto ou de seu `.claude/settings.json` durante a agregação
- [x] 2.7 Garantir que o script não tenta clonar repositórios nem lê/escreve nenhum manifesto JSON/YAML de repositórios

## 3. Documentação de governança

- [x] 3.1 Escrever `movie-sample-ai/AGENTS.md` com: convenções gerais/cross-cutting do workspace, catálogo de repositórios (tabela com os 4 repositórios e descrição curta), passo a passo de montagem do workspace, e a regra de divisão entre informação geral (aqui) e específica (em cada subprojeto)
- [x] 3.2 Escrever `movie-sample-ai/CLAUDE.md` redirecionando para `movie-sample-ai/AGENTS.md`
- [x] 3.3 Escrever `movie-sample-ai/README.md` com o catálogo de repositórios e o passo a passo de montagem do workspace, voltado a quem chega no projeto sem contexto

## 4. Spec de domínio Movie

- [x] 4.1 Criar `movie-sample-ai/specs/specs/movie-domain-spec/spec.md` documentando os campos, tipos e regras de validação do `Movie` (identidade interna/externa, título, ano, gênero, diretor, sinopse, duração) como contrato compartilhado entre `movie-sample-server` e `movie-sample-front`

## 5. Docker Compose unificado

- [x] 5.1 Criar `movie-sample-ai/docker-compose.yml` com serviços esqueleto para `movie-sample-gateway`, `movie-sample-server`, `movie-sample-front` e `mysql`, documentando no próprio arquivo (comentários) que os serviços de aplicação serão completados quando os respectivos repositórios existirem

## 6. Validação

- [x] 6.1 Rodar `scripts/init-workspace.sh` a partir de um `workspace` de teste contendo apenas o `movie-sample-ai` (sem os outros 3 repositórios) e confirmar que ele completa sem erro, criando os symlinks e stubs esperados
- [x] 6.2 Confirmar que os stubs gerados (`CLAUDE.md`, `AGENTS.md`, `.claude/settings.json`) na raiz do workspace de teste têm o conteúdo esperado
- [x] 6.3 Validar as specs criadas com `openspec validate` (ou equivalente) antes de considerar a mudança pronta para archive
