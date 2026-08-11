# AGENTS.md — movie-sample-ai

Este arquivo é a **fonte única de verdade** sobre as convenções gerais e cross-cutting
do workspace do catálogo de filmes. Informação específica de cada subprojeto mora no
`AGENTS.md` daquele subprojeto — veja "Divisão de responsabilidade" abaixo.

## O que é este workspace

O catálogo de filmes é composto por 4 repositórios, organizados como pastas irmãs
dentro de um workspace local que **não é versionado em git**:

```
workspace/
├── movie-sample-ai/        (este repositório)
├── movie-sample-gateway/
├── movie-sample-server/
└── movie-sample-front/
```

O Claude Code é sempre inicializado na raiz do `workspace` — nunca dentro de um
subprojeto isoladamente, no fluxo principal de trabalho.

## Catálogo de repositórios

| Repositório              | Descrição                                                                 |
|---------------------------|----------------------------------------------------------------------------|
| `movie-sample-ai`          | Specs (OpenSpec), skills, agents e este `AGENTS.md` — fonte única de verdade e ponto de partida do workspace |
| `movie-sample-gateway`      | Spring Cloud Gateway — fachada única de roteamento (`/api/**` → backend, demais rotas → front) |
| `movie-sample-server`       | API Spring (multi-módulo `api`/`core`) — cadastro de filmes                |
| `movie-sample-front`         | Aplicação Next.js — interface gráfica do catálogo                          |

## Como montar o workspace

1. Crie uma pasta local qualquer para servir de raiz do `workspace` (ela não precisa,
   e não deve, ser um repositório git).
2. Clone os 4 repositórios lado a lado dentro dela:
   ```
   git clone <url>/movie-sample-ai.git
   git clone <url>/movie-sample-gateway.git
   git clone <url>/movie-sample-server.git
   git clone <url>/movie-sample-front.git
   ```
   (é normal montar o workspace só com o `movie-sample-ai`, ou com qualquer
   subconjunto dos subprojetos — o script abaixo lida com subprojetos ausentes.)
3. Rode o script de inicialização a partir de dentro do `movie-sample-ai`:
   ```
   ./movie-sample-ai/scripts/init-workspace.sh
   ```
4. Abra o Claude Code a partir da raiz do `workspace`.

O que o script faz, em resumo (detalhes na spec `workspace-init-script`):
- Instala/inicializa o OpenSpec na raiz do workspace.
- Cria o symlink `openspec/` → `movie-sample-ai/specs/`.
- Linka as skills/agents customizados de `movie-sample-ai/.ai/{skills,agents}` para
  dentro de `.claude/{skills,agents}` da raiz, ao lado das skills nativas do OpenSpec.
- Gera `CLAUDE.md`/`AGENTS.md` na raiz como stubs somente-leitura apontando para este
  arquivo.
- Agrega os plugins do Claude Code declarados em cada subprojeto (`.claude/settings.json`)
  num único `.claude/settings.json` na raiz do workspace.

O script é seguro de rodar de novo a qualquer momento — ele reflete o estado atual dos
repositórios presentes no `workspace`.

## Divisão de responsabilidade: geral vs. específico

- **Informação geral/cross-cutting** (convenções compartilhadas, contrato de domínio
  usado por mais de um repositório) mora **aqui**, no `movie-sample-ai` — neste
  `AGENTS.md` ou como spec em `specs/specs/`.
- **Informação específica de um subprojeto** (como o `gateway` estrutura suas rotas,
  como o `server` separa os módulos `api`/`core`, decisões de UI do `front`) mora no
  `AGENTS.md` daquele subprojeto, não aqui.

Ao decidir onde documentar algo, pergunte: "mais de um repositório precisa concordar
com isso?" Se sim, é geral. Se só um repositório é afetado, é específico dele.

## Contrato de domínio compartilhado

O modelo do `Movie` — campos, tipos e regras de validação — é o contrato entre
`movie-sample-server` (implementação) e `movie-sample-front` (consumo). A fonte única
de verdade desse contrato é a spec `specs/specs/movie-domain-spec/spec.md`. Qualquer
implementação que divergir dela deve ser corrigida para segui-la, não o contrário.

## Convenções compartilhadas entre repositórios de backend

`movie-sample-gateway` e `movie-sample-server` compartilham a mesma base tecnológica:
Gradle (Groovy DSL) com catálogo de versões via TOML, Java 25, Spring Boot 4.1.
Detalhes específicos de cada um (módulos, dependências, estilo reativo vs. MVC) estão
no `AGENTS.md` de cada repositório.

## Spec-Driven Development neste workspace

Mudanças neste workspace seguem o fluxo do OpenSpec:
`/opsx:explore` (opcional, para pensar antes de propor) → `/opsx:propose` (cria
proposta + specs + design + tasks) → `/opsx:apply` (implementa) → `/opsx:archive`
(consolida specs). As specs vivas do workspace ficam em `specs/specs/`; propostas em
andamento ou arquivadas ficam em `specs/changes/`.

## Plugins do Claude Code

Se um subprojeto depende de um plugin do Claude Code (ex: um plugin de geração de UI
para o `movie-sample-front`), ele declara essa dependência no seu próprio
`.claude/settings.json` (`enabledPlugins`/`extraKnownMarketplaces`). O
`init-workspace.sh` agrega essas declarações no `.claude/settings.json` da raiz do
workspace — é lá que a configuração de fato tem efeito, já que o Claude Code só lê
`.claude/settings.json` da raiz onde a sessão foi iniciada, sem cascatear como o
`CLAUDE.md`.
