#!/bin/bash
# Dev-Stacks Tool Discovery Scanner
# Scans MCP servers, plugins, and skills available in the system
# Compatible with Bash 3.2+ (macOS default)

set -e

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
REGISTRY_FILE="$PLUGIN_ROOT/.dev-stacks/registry.json"

# Ensure directory exists
mkdir -p "$(dirname "$REGISTRY_FILE")"

# Scan MCP servers from .claude/settings.local.json or .mcp.json
scan_mcp_servers() {
  local mcp_file="$HOME/.claude/settings.local.json"
  local servers="[]"

  # Try settings.local.json first
  if [[ -f "$mcp_file" ]]; then
    servers=$(jq -c '[.mcpServers // {} | keys[]]' "$mcp_file" 2>/dev/null || echo "[]")
  fi

  # Fallback to project .mcp.json
  if [[ "$servers" == "[]" ]]; then
    local project_mcp="$PLUGIN_ROOT/.mcp.json"
    if [[ -f "$project_mcp" ]]; then
      servers=$(jq -c '[.mcpServers // {} | keys[]]' "$project_mcp" 2>/dev/null || echo "[]")
    fi
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
  local skills_dir="$PLUGIN_ROOT/skills"

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
