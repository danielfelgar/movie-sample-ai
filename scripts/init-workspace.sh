#!/usr/bin/env bash
#
# init-workspace.sh
#
# Conecta o workspace local à fonte única de verdade mantida em
# movie-sample-ai: specs do OpenSpec, skills/agents customizados, e os plugins do
# Claude Code declarados por cada subprojeto.
#
# Pressupõe que movie-sample-gateway, movie-sample-server e movie-sample-front
# (quando presentes) já existem como pastas irmãs de movie-sample-ai. Este script
# NÃO clona repositórios e NÃO lê/mantém nenhum manifesto JSON/YAML de repositórios —
# a lista de subprojetos abaixo é usada apenas para verificar presença, não para clonar.
#
# Requisitos: OpenSpec CLI (instalado via npm automaticamente se ausente), jq.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOVIE_SAMPLE_AI_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKSPACE_ROOT="$(cd "${MOVIE_SAMPLE_AI_DIR}/.." && pwd)"

SUBPROJECTS=(movie-sample-gateway movie-sample-server movie-sample-front)

log() { echo "==> $*"; }

require_jq() {
  if ! command -v jq >/dev/null 2>&1; then
    echo "ERRO: 'jq' é necessário para agregar .claude/settings.json dos subprojetos." >&2
    echo "Instale jq (ex: 'brew install jq') e rode o script novamente." >&2
    exit 1
  fi
}

install_openspec_cli() {
  if ! command -v openspec >/dev/null 2>&1; then
    log "OpenSpec CLI não encontrado — instalando globalmente via npm..."
    npm install -g openspec
  fi
}

# Inicializa o OpenSpec na raiz do workspace e substitui a pasta openspec/ real
# gerada pelo `openspec init` por um symlink para movie-sample-ai/specs — que é
# onde as specs de fato vivem, versionadas e compartilhadas entre todo o workspace.
wire_openspec_specs() {
  log "Inicializando OpenSpec na raiz do workspace..."
  (cd "${WORKSPACE_ROOT}" && openspec init --tools claude --force .)

  if [ -f "${WORKSPACE_ROOT}/openspec/config.yaml" ] && [ ! -L "${WORKSPACE_ROOT}/openspec" ]; then
    mv -f "${WORKSPACE_ROOT}/openspec/config.yaml" "${MOVIE_SAMPLE_AI_DIR}/specs/config.yaml"
  fi

  if [ -e "${WORKSPACE_ROOT}/openspec" ] && [ ! -L "${WORKSPACE_ROOT}/openspec" ]; then
    rm -rf "${WORKSPACE_ROOT}/openspec"
  fi

  ln -sfn "${MOVIE_SAMPLE_AI_DIR}/specs" "${WORKSPACE_ROOT}/openspec"
  log "openspec -> movie-sample-ai/specs (symlink pronto)"
}

# Symlinka cada skill/agent customizado individualmente (não a pasta .claude/skills
# ou .claude/agents inteira), porque essas pastas na raiz também hospedam as skills
# e comandos nativos do OpenSpec (opsx:*) instalados por `openspec init` — que não
# são versionados dentro de movie-sample-ai.
link_custom_skills_and_agents() {
  mkdir -p "${WORKSPACE_ROOT}/.claude/skills" "${WORKSPACE_ROOT}/.claude/agents"

  if [ -d "${MOVIE_SAMPLE_AI_DIR}/.ai/skills" ]; then
    for skill_dir in "${MOVIE_SAMPLE_AI_DIR}"/.ai/skills/*/; do
      [ -d "$skill_dir" ] || continue
      name="$(basename "$skill_dir")"
      ln -sfn "$skill_dir" "${WORKSPACE_ROOT}/.claude/skills/${name}"
      log "Skill customizada linkada: ${name}"
    done
  fi

  if [ -d "${MOVIE_SAMPLE_AI_DIR}/.ai/agents" ]; then
    for agent_dir in "${MOVIE_SAMPLE_AI_DIR}"/.ai/agents/*/; do
      [ -d "$agent_dir" ] || continue
      name="$(basename "$agent_dir")"
      ln -sfn "$agent_dir" "${WORKSPACE_ROOT}/.claude/agents/${name}"
      log "Agent customizado linkado: ${name}"
    done
  fi
}

# Gera (não symlinka) os stubs de redirecionamento na raiz do workspace.
generate_root_stub_docs() {
  local warning
  warning=$(cat <<'EOF'
ARQUIVO GERADO AUTOMATICAMENTE por movie-sample-ai/scripts/init-workspace.sh.
NÃO EDITE manualmente nem via agentes — suas alterações serão perdidas na
próxima execução do script.
EOF
)

  cat > "${WORKSPACE_ROOT}/CLAUDE.md" <<EOF
# CLAUDE.md (raiz do workspace)

${warning}

A fonte única de verdade deste workspace é movie-sample-ai/AGENTS.md — leia esse
arquivo para entender as convenções gerais, a estrutura do workspace e como cada
subprojeto (movie-sample-gateway, movie-sample-server, movie-sample-front) se
relaciona com os demais.
EOF

  cat > "${WORKSPACE_ROOT}/AGENTS.md" <<EOF
# AGENTS.md (raiz do workspace)

${warning}

A fonte única de verdade deste workspace é movie-sample-ai/AGENTS.md — leia esse
arquivo para entender as convenções gerais, a estrutura do workspace e como cada
subprojeto (movie-sample-gateway, movie-sample-server, movie-sample-front) se
relaciona com os demais.
EOF

  log "Stubs CLAUDE.md e AGENTS.md gerados na raiz do workspace."
}

# Agrega enabledPlugins/extraKnownMarketplaces do .claude/settings.json de cada
# subprojeto presente no .claude/settings.json da raiz do workspace. A ausência de
# um subprojeto, ou de seu settings.json, não é um erro — apenas nada é agregado
# daquele repositório.
aggregate_plugin_settings() {
  require_jq

  local settings_file="${WORKSPACE_ROOT}/.claude/settings.json"
  local merged='{"enabledPlugins":[],"extraKnownMarketplaces":{}}'
  local found_any=0

  for sub in "${SUBPROJECTS[@]}"; do
    local sub_settings="${WORKSPACE_ROOT}/${sub}/.claude/settings.json"
    if [ -f "$sub_settings" ]; then
      log "Agregando plugins declarados em ${sub}/.claude/settings.json"
      merged="$(jq -s '
        .[0] as $acc | .[1] as $new |
        {
          enabledPlugins: (($acc.enabledPlugins // []) + ($new.enabledPlugins // []) | unique),
          extraKnownMarketplaces: (($acc.extraKnownMarketplaces // {}) * ($new.extraKnownMarketplaces // {}))
        }' <(printf '%s' "$merged") "$sub_settings")"
      found_any=1
    else
      log "${sub}: ausente ou sem .claude/settings.json — nada a agregar"
    fi
  done

  mkdir -p "${WORKSPACE_ROOT}/.claude"

  if [ "$found_any" -eq 1 ]; then
    # Preserva outras chaves já presentes no settings.json da raiz (ex: hooks locais);
    # enabledPlugins/extraKnownMarketplaces são sempre regenerados por este script.
    if [ -f "$settings_file" ]; then
      merged="$(jq -s '.[1] * .[0]' <(printf '%s' "$merged") "$settings_file")"
    fi
    printf '%s\n' "$merged" | jq '.' > "$settings_file"
    log "settings.json da raiz atualizado com plugins agregados dos subprojetos."
  else
    log "Nenhum subprojeto com plugins declarados encontrado — nada a agregar."
  fi
}

main() {
  log "Inicializando workspace em: ${WORKSPACE_ROOT}"
  install_openspec_cli
  wire_openspec_specs
  link_custom_skills_and_agents
  generate_root_stub_docs
  aggregate_plugin_settings
  log "Workspace pronto."
}

main "$@"
