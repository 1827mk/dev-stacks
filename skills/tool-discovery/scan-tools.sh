#!/bin/bash
# Dev-Stacks Tool Discovery Scanner
# Scans MCP servers, plugins, and skills available in the system
# Compatible with Bash 3.2+ (macOS default)
#
# Usage: scan-tools.sh [PROJECT_PATH]
# If PROJECT_PATH is provided, use it instead of CLAUDE_PLUGIN_ROOT

set -e

# Accept project path as first argument, or use CLAUDE_PLUGIN_ROOT, or derive from script location
if [[ -n "${1:-}" ]]; then
  PROJECT_ROOT="$1"
elif [[ -n "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
  # When running from plugin, CLAUDE_PLUGIN_ROOT points to plugin cache
  # We need to use the actual project directory (cwd of the session)
  PROJECT_ROOT="${PWD}"
else
  PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
fi

REGISTRY_FILE="$PROJECT_ROOT/.dev-stacks/registry.json"

# Ensure directory exists
mkdir -p "$(dirname "$REGISTRY_FILE")"

# Scan MCP servers from multiple sources
scan_mcp_servers() {
  local servers="[]"

  # Method 1: Check settings.local.json
  local settings_local="$HOME/.claude/settings.local.json"
  if [[ -f "$settings_local" ]]; then
    servers=$(jq -c '[.mcpServers // {} | keys[]]' "$settings_local" 2>/dev/null || echo "[]")
  fi

  # Method 2: Check settings.json
  if [[ "$servers" == "[]" ]]; then
    local settings="$HOME/.claude/settings.json"
    if [[ -f "$settings" ]]; then
      servers=$(jq -c '[.mcpServers // {} | keys[]]' "$settings" 2>/dev/null || echo "[]")
    fi
  fi

  # Method 3: Check project .mcp.json
  if [[ "$servers" == "[]" ]]; then
    local project_mcp="$PROJECT_ROOT/.mcp.json"
    if [[ -f "$project_mcp" ]]; then
      servers=$(jq -c '[.mcpServers // {} | keys[]]' "$project_mcp" 2>/dev/null || echo "[]")
    fi
  fi

  # Method 4: Check for common MCP server config patterns
  if [[ "$servers" == "[]" ]]; then
    # List known MCP server directories
    local known_servers=()
    local mcp_dir="$HOME/.claude/mcp"

    if [[ -d "$mcp_dir" ]]; then
      while IFS= read -r dir; do
        [[ -n "$dir" ]] && known_servers+=("$(basename "$dir")")
      done < <(ls -1d "$mcp_dir"/*/ 2>/dev/null)
    fi

    if [[ ${#known_servers[@]} -gt 0 ]]; then
      servers=$(printf '%s\n' "${known_servers[@]}" | jq -R . | jq -s .)
    fi
  fi

  # Method 5: Hardcoded common servers (fallback)
  if [[ "$servers" == "[]" ]]; then
    # These are commonly available MCP servers
    servers='["serena", "context7", "memory", "filesystem", "fetch", "web_reader", "sequentialthinking", "doc-forge", "4_5v_mcp", "plugin_chrome-devtools-mcp_chrome-devtools"]'
  fi

  echo "$servers"
}

# Scan available plugins
scan_plugins() {
  local plugins_dir="$HOME/.claude/plugins/cache/claude-plugins-official"
  local plugins="[]"

  if [[ -d "$plugins_dir" ]]; then
    plugins=$(ls -1 "$plugins_dir" 2>/dev/null | grep -v "^\." | jq -R -s -c 'split("\n") | map(select(length > 0))' || echo "[]")
  fi

  echo "$plugins"
}

# Scan skills from this plugin (simplified, no associative arrays)
scan_skills() {
  local skills_dir="$PROJECT_ROOT/skills"

  if [[ ! -d "$skills_dir" ]]; then
    echo '{"planning":[],"implementation":[],"verification":[],"git":[],"other":[]}'
    return
  fi

  # Find all SKILL.md files and categorize
  local planning="[]"
  local implementation="[]"
  local verification="[]"
  local git="[]"
  local other="[]"

  while IFS= read -r skill_file; do
    [[ -z "$skill_file" ]] && continue

    local skill_name=$(basename "$(dirname "$skill_file")")
    local skill_path=$(dirname "$skill_file" | sed "s|$skills_dir/||")

    # Categorize based on path and description
    local category="other"

    # Check path
    case "$skill_path" in
      core/orchestrator|core/intent-router|core/complexity-scorer|core/team-selector)
        category="planning"
        ;;
      workflows/*)
        category="planning"
        ;;
    esac

    # Check description if file exists
    if [[ -f "$skill_file" ]]; then
      local desc=$(grep -A2 "^description:" "$skill_file" 2>/dev/null | tr '\n' ' ' || echo "")

      if echo "$desc" | grep -qi "plan\|brainstorm\|design\|orchestrat"; then
        category="planning"
      elif echo "$desc" | grep -qi "implement\|build\|create"; then
        category="implementation"
      elif echo "$desc" | grep -qi "test\|verify\|review\|quality"; then
        category="verification"
      elif echo "$desc" | grep -qi "git\|commit\|merge"; then
        category="git"
      fi
    fi

    # Add to appropriate category
    case "$category" in
      planning)
        planning=$(echo "$planning" | jq -c --arg s "$skill_name" '. + [$s]')
        ;;
      implementation)
        implementation=$(echo "$implementation" | jq -c --arg s "$skill_name" '. + [$s]')
        ;;
      verification)
        verification=$(echo "$verification" | jq -c --arg s "$skill_name" '. + [$s]')
        ;;
      git)
        git=$(echo "$git" | jq -c --arg s "$skill_name" '. + [$s]')
        ;;
      *)
        other=$(echo "$other" | jq -c --arg s "$skill_name" '. + [$s]')
        ;;
    esac
  done < <(find "$skills_dir" -name "SKILL.md" 2>/dev/null)

  # Build JSON object
  jq -n -c \
    --argjson planning "$planning" \
    --argjson implementation "$implementation" \
    --argjson verification "$verification" \
    --argjson git "$git" \
    --argjson other "$other" \
    '{planning: $planning, implementation: $implementation, verification: $verification, git: $git, other: $other}'
}

# Build tool keyword mappings
build_keyword_mappings() {
  cat << 'EOF'
{
  "frontend-design": ["UI", "component", "page", "frontend", "react", "vue", "css", "style"],
  "systematic-debugging": ["bug", "error", "fix", "debug", "crash", "exception"],
  "claude-api": ["API", "anthropic", "claude", "SDK", "llm"],
  "code-review": ["review", "quality", "check", "audit"],
  "context7": ["docs", "documentation", "library", "reference"],
  "web_reader": ["web", "url", "fetch", "scrape", "read"],
  "WebSearch": ["search", "find", "lookup", "google"],
  "serena": ["codebase", "symbol", "find", "reference", "analyze"],
  "memory": ["remember", "pattern", "save", "knowledge"],
  "test-driven-development": ["test", "TDD", "spec", "unit test"],
  "brainstorming": ["idea", "design", "feature", "new", "create"],
  "writing-plans": ["plan", "steps", "implementation", "roadmap"],
  "chrome-devtools": ["browser", "debug", "inspect", "console"]
}
EOF
}

# Main scan function
main() {
  echo "🔍 Scanning available tools..."

  # Scan each category
  local mcp_servers=$(scan_mcp_servers)
  local plugins=$(scan_plugins)
  local skills=$(scan_skills)
  local keywords=$(build_keyword_mappings)

  # Build final registry
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  jq -n \
    --arg version "1.0.0" \
    --arg ts "$timestamp" \
    --argjson mcp "$mcp_servers" \
    --argjson plugins "$plugins" \
    --argjson skills "$skills" \
    --argjson keywords "$keywords" \
    '{
      version: $version,
      last_scan: $ts,
      mcp_servers: $mcp,
      plugins: $plugins,
      skills: $skills,
      tool_keywords: $keywords
    }' > "$REGISTRY_FILE"

  echo "✅ Registry updated: $REGISTRY_FILE"
  echo ""
  echo "📊 Discovered:"
  jq -r '.mcp_servers | length | "  MCP Servers: \(.)"' "$REGISTRY_FILE" 2>/dev/null || echo "  MCP Servers: 0"
  jq -r '.plugins | length | "  Plugins: \(.)"' "$REGISTRY_FILE" 2>/dev/null || echo "  Plugins: 0"
  jq -r '[.skills | .[]] | add | length | "  Skills: \(.)"' "$REGISTRY_FILE" 2>/dev/null || echo "  Skills: 0"
}

main "$@"
