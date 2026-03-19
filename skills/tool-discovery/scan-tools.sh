#!/bin/bash
# Dev-Stacks Tool Discovery Scanner
# Scans MCP servers, plugins, and skills available in the system

set -e

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
REGISTRY_FILE="$PLUGIN_ROOT/.dev-stacks/registry.json"

# Ensure directory exists
mkdir -p "$(dirname "$REGISTRY_FILE")"

# Initialize registry structure
initialize_registry() {
  cat > "$REGISTRY_FILE" << 'EOF'
{
  "version": "1.0.0",
  "last_scan": "",
  "mcp_servers": [],
  "plugins": [],
  "skills": {
    "planning": [],
    "implementation": [],
    "verification": [],
    "git": [],
    "parallel": [],
    "other": []
  },
  "tool_keywords": {}
}
EOF
}

# Scan MCP servers from .mcp.json
scan_mcp_servers() {
  local mcp_file="$PLUGIN_ROOT/.mcp.json"
  local servers=()

  if [[ -f "$mcp_file" ]]; then
    # Extract MCP server names
    servers=$(jq -r '.mcpServers | keys[]' "$mcp_file" 2>/dev/null || echo "")
  fi

  echo "$servers"
}

# Scan available plugins
scan_plugins() {
  local plugins_dir="$HOME/.claude/plugins/cache/claude-plugins-official"
  local plugins=()

  if [[ -d "$plugins_dir" ]]; then
    plugins=$(ls -1 "$plugins_dir" 2>/dev/null | grep -v "^\." || echo "")
  fi

  echo "$plugins"
}

# Scan skills from this plugin
scan_skills() {
  local skills_dir="$PLUGIN_ROOT/skills"
  declare -A skill_categories

  if [[ -d "$skills_dir" ]]; then
    # Find all SKILL.md files
    while IFS= read -r -d '' skill_file; do
      local skill_name=$(basename "$(dirname "$skill_file")")
      local skill_path=$(dirname "$skill_file" | sed "s|$skills_dir/||")

      # Categorize based on directory
      case "$skill_path" in
        core/*) category="planning" ;;
        tool-discovery) category="other" ;;
        *) category="other" ;;
      esac

      # Also check description for categorization
      if [[ -f "$skill_file" ]]; then
        local desc=$(grep -A1 "^description:" "$skill_file" 2>/dev/null | head -2 || echo "")

        if echo "$desc" | grep -qi "plan\|brainstorm\|design"; then
          category="planning"
        elif echo "$desc" | grep -qi "implement\|build\|create"; then
          category="implementation"
        elif echo "$desc" | grep -qi "test\|verify\|review"; then
          category="verification"
        elif echo "$desc" | grep -qi "git\|commit\|merge"; then
          category="git"
        fi
      fi

      skill_categories[$category]+="$skill_name "
    done < <(find "$skills_dir" -name "SKILL.md" -print0 2>/dev/null)
  fi

  # Output categorized skills
  for cat in planning implementation verification git other; do
    echo "$cat: ${skill_categories[$cat]}"
  done
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

  # Initialize if needed
  if [[ ! -f "$REGISTRY_FILE" ]]; then
    initialize_registry
  fi

  # Scan each category
  local mcp_servers=$(scan_mcp_servers)
  local plugins=$(scan_plugins)
  local keywords=$(build_keyword_mappings)

  # Parse skill categories
  declare -A skills_by_category
  while IFS= read -r line; do
    if [[ -n "$line" ]]; then
      category=$(echo "$line" | cut -d: -f1 | tr -d ' ')
      skill_list=$(echo "$line" | cut -d: -f2- | tr -d ' ' | sed 's/  */","/g' | sed 's/^"//;s/"$//')
      if [[ -n "$skill_list" ]]; then
        skills_by_category[$category]="[\"$skill_list\"]"
      fi
    fi
  done < <(scan_skills)

  # Build final registry
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  jq --arg ts "$timestamp" \
     --argjson mcp "[]" \
     --argjson plugins "[]" \
     --argjson keywords "$keywords" \
     --arg planning "${skills_by_category[planning]:-[]}" \
     --arg implementation "${skills_by_category[implementation]:-[]}" \
     --arg verification "${skills_by_category[verification]:-[]}" \
     --arg git "${skills_by_category[git]:-[]}" \
     --arg other "${skills_by_category[other]:-[]}" \
    '.last_scan = $ts |
     .mcp_servers = $mcp |
     .plugins = $plugins |
     .skills.planning = ($planning | fromjson) |
     .skills.implementation = ($implementation | fromjson) |
     .skills.verification = ($verification | fromjson) |
     .skills.git = ($git | fromjson) |
     .skills.other = ($other | fromjson) |
     .tool_keywords = $keywords' \
    "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp" && mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"

  echo "✅ Registry updated: $REGISTRY_FILE"
  echo ""
  echo "📊 Discovered:"
  jq -r '.mcp_servers | length | "  MCP Servers: \(.)"' "$REGISTRY_FILE" 2>/dev/null || echo "  MCP Servers: 0"
  jq -r '.plugins | length | "  Plugins: \(.)"' "$REGISTRY_FILE" 2>/dev/null || echo "  Plugins: 0"
  jq -r '[.skills | .[]] | add | length | "  Skills: \(.)"' "$REGISTRY_FILE" 2>/dev/null || echo "  Skills: 0"
}

main "$@"
