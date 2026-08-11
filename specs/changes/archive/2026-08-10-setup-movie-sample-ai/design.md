## Context

O `movie-sample-ai` é o primeiro dos 4 repositórios do workspace do catálogo de filmes a ser implementado. Os outros três (`movie-sample-gateway`, `movie-sample-server`, `movie-sample-front`) ainda não existem como repositórios de código — este design cobre apenas o `movie-sample-ai`, mas várias decisões aqui (symlinks, `.claude/settings.json`, divisão de conteúdo geral vs. específico) definem um padrão que os outros três repositórios deverão seguir quando forem criados.

Premissas herdadas da exploração que motivam este design:
- Os 4 repositórios vivem como pastas irmãs dentro de uma `workspace` que **não é versionada em git** — é inteiramente reconstruível a partir do conteúdo dos repositórios reais.
- O Claude Code é sempre inicializado na raiz do `workspace`, nunca dentro de um subprojeto isolado, no fluxo principal de trabalho.
- Este projeto é a base de um artigo técnico sobre organização de múltiplos repositórios com `AGENTS.md` como single source of truth e Spec-Driven Development via OpenSpec — clareza pedagógica é um objetivo tão importante quanto corretude técnica.

## Goals / Non-Goals

**Goals:**
- Definir a estrutura de pastas do `movie-sample-ai` e o comportamento do `scripts/init-workspace.sh` que conecta este repositório ao restante do workspace.
- Garantir que specs, skills e agents definidos aqui fiquem acessíveis a partir da raiz do `workspace` via symlinks, sem duplicação de conteúdo.
- Garantir que plugins declarados por subprojetos (ex: `frontend-design` no futuro `movie-sample-front`) efetivamente funcionem quando o Claude Code é iniciado na raiz do `workspace` — não apenas quando o subprojeto é aberto isoladamente.
- Registrar o contrato de domínio (`Movie`) como spec, servindo de referência para os repositórios de aplicação que serão implementados em mudanças futuras.
- Deixar o `docker-compose.yml` unificado esboçado neste repositório, mesmo sem os demais repositórios existirem ainda.

**Non-Goals:**
- Implementar código dos repositórios `movie-sample-gateway`, `movie-sample-server` ou `movie-sample-front` — isso é escopo de mudanças futuras.
- Clonar repositórios automaticamente ou manter uma lista de repositórios em JSON/YAML — o script assume que os 4 repositórios já existem lado a lado.
- Resolver o objetivo adicional do `init-workspace.sh` mencionado durante a exploração e explicitamente adiado — fica fora do escopo desta mudança.
- Fechar os detalhes finos do `docker-compose.yml` (variáveis de ambiente completas, healthchecks, volumes) — o compose criado aqui é um esqueleto que referencia os 3 serviços de aplicação e o banco de dados; será refinado quando os repositórios de aplicação existirem.

## Decisions

### 1. Distribuição de specs/skills/agents via symlink, não cópia nem submodule
A raiz do workspace (`workspace`) recebe `openspec/`, `.claude/skills/` e `.claude/agents/` como symlinks apontando para dentro do `movie-sample-ai` (`specs/`, `.ai/skills/`, `.ai/agents/`).

**Alternativas consideradas:**
- *Cópia via script*: mais portátil (funciona fora do filesystem local), mas gera drift — editar a fonte não reflete automaticamente, exigindo reexecução do script para sincronizar.
- *Git submodule*: sincronização explícita e funciona em CI, mas adiciona fricção de uso (`git submodule update`) desnecessária para um workspace local não versionado.
- *Symlink (escolhido)*: edição em um lugar reflete instantaneamente em todos os pontos de uso; como o `workspace` não é versionado em git, os problemas usuais de symlink em CI/repositórios remotos não se aplicam aqui.

### 2. `workspace/CLAUDE.md` e `AGENTS.md` são arquivos gerados, não symlinks
São gerados pelo script como stubs de redirecionamento para `movie-sample-ai/AGENTS.md`, com aviso de "não editar manualmente nem via agentes".

**Por quê não symlink também aqui:** symlinkar diretamente o `AGENTS.md` do `movie-sample-ai` para a raiz faria a raiz parecer "dona" do conteúdo geral, quando na verdade o conteúdo pertence ao `movie-sample-ai`. Gerar um stub deixa explícito que a raiz é só um ponto de entrada, reforçando onde é a fonte única de verdade real.

### 3. `.claude/settings.json` da raiz do workspace é gerado por agregação, não por symlink
Descoberta técnica during a exploração: `.claude/settings.json` **não cascateia** entre diretórios como o `CLAUDE.md` — o Claude Code só lê o `settings.json` da raiz onde a sessão foi iniciada. Isso significa que declarações de plugin feitas dentro de um subprojeto (ex: `movie-sample-front/.claude/settings.json` declarando o plugin `frontend-design`) seriam ignoradas no fluxo principal, que sempre inicia na raiz do `workspace`.

**Decisão:** o `init-workspace.sh` lê o `.claude/settings.json` de cada subprojeto presente no workspace e agrega os campos `enabledPlugins`/`extraKnownMarketplaces` num `.claude/settings.json` gerado na raiz. Cada subprojeto continua sendo a fonte de verdade sobre qual plugin ele precisa (e esse arquivo local ainda é útil no caso de uso "abrir o subprojeto sozinho"), mas a agregação é o que faz a declaração ter efeito real no fluxo de trabalho principal.

**Alternativa considerada:** declarar todos os plugins diretamente no `movie-sample-ai` (centralizando também essa informação). Rejeitada porque contradiz a regra já estabelecida de que informação específica de um subprojeto pertence a ele, não ao `movie-sample-ai` — a agregação automática preserva essa fronteira sem sacrificar o funcionamento técnico.

### 4. Modelo de domínio `Movie` como spec no `movie-sample-ai`, não documentação implícita no código do server
O modelo do `Movie` (campos, tipos, regras de validação) é contrato compartilhado entre `movie-sample-server` (implementação) e `movie-sample-front` (consumo). Documentá-lo como spec aqui, em vez de deixá-lo implícito na entidade JPA do server, torna-o a fonte única de verdade que ambos os repositórios de aplicação devem seguir — consistente com a regra de que informação cross-cutting mora no `movie-sample-ai`.

### 5. Catálogo de repositórios e passo a passo de setup são mantidos manualmente
Não há geração automática a partir de um arquivo de configuração — o catálogo de repositórios no `AGENTS.md`/`README.md` é texto de documentação mantido manualmente. Trade-off aceito conscientemente: menos automação, mas evita a complexidade de manter (e o script de ler) um manifesto de repositórios que, neste projeto, não teria outro uso.

## Risks / Trade-offs

- **[Risco] Symlinks não se comportam de forma idêntica em todos os SOs** (ex.: diferenças de symlink em Windows) → **Mitigação**: fora de escopo por ora — o projeto assume ambiente Unix-like (macOS/Linux), consistente com o ambiente de desenvolvimento do artigo.
- **[Risco] `AGENTS.md`/`CLAUDE.md` gerados na raiz podem ser editados manualmente por engano, gerando drift silencioso** → **Mitigação**: o aviso explícito de "não editar" no conteúdo do arquivo é a única salvaguarda nesta mudança; não há verificação automática (ex.: hash/checksum) que impeça edição manual.
- **[Risco] Agregação de `settings.json` pode falhar silenciosamente se um subprojeto ainda não existir ou não tiver `.claude/settings.json`** → **Mitigação**: o script deve tratar a ausência de um subprojeto ou de seu `settings.json` como "nada a agregar daquele repositório", sem erro — importante porque, no momento desta mudança, os outros 3 repositórios ainda não existem.
- **[Risco] `docker-compose.yml` criado antes dos repositórios de aplicação existirem pode ficar desatualizado em relação aos Dockerfiles reais quando eles forem criados** → **Mitigação**: tratado como esqueleto/non-goal de detalhamento fino; revisão esperada como parte das mudanças futuras que implementam `gateway`/`server`/`front`.

## Migration Plan

Não aplicável no sentido tradicional (não há sistema em produção sendo migrado). Ordem de execução desta mudança:
1. Criar estrutura de pastas e arquivos estáticos (`AGENTS.md`, `CLAUDE.md`, `README.md`, `.ai/`, `specs/`, `docker-compose.yml`).
2. Implementar `scripts/init-workspace.sh`.
3. Validar manualmente rodando o script a partir de uma `workspace` de teste (mesmo sem os outros 3 repositórios existirem, o script deve rodar sem erro, criando os symlinks/arquivos que dependem só do `movie-sample-ai`).

## Open Questions

- Objetivo adicional do `init-workspace.sh` mencionado na exploração, explicitamente adiado pelo usuário — a revisitar em mudança futura.
- Detalhes finos do `docker-compose.yml` (variáveis de ambiente completas, healthchecks, dependências entre serviços) — a fechar quando os repositórios `gateway`/`server`/`front` existirem de fato.
