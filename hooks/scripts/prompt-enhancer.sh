#!/usr/bin/env bash
# dev-stacks v3 — UserPromptSubmit: intent classification + state write

set -euo pipefail

# Resolve plugin root: try env var, then derive from script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$SCRIPT_DIR")")}"

INPUT=$(cat)

# JSON fields (note: Claude sends 'prompt', not 'user_prompt')
USER_PROMPT=$(printf '%s' "$INPUT" | jq -r '.prompt // .user_prompt // ""')
SESSION_ID=$(printf '%s' "$INPUT"  | jq -r '.session_id // "unknown"')
CWD=$(printf '%s' "$INPUT"         | jq -r '.cwd // ""')

# Skip slash commands
[[ "$USER_PROMPT" == /* ]] && exit 0

# Skip empty / very short prompts
[[ -z "$USER_PROMPT" || ${#USER_PROMPT} -lt 2 ]] && exit 0

# State lives in project dir
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
DS_DIR="$PROJECT_DIR/.dev-stacks"
STATE_PATH="$DS_DIR/state.json"
REGISTRY_PATH="${PLUGIN_ROOT}/registry.json"

# Skip if registry missing (first-run before /dev-stacks:init)
[[ ! -f "$REGISTRY_PATH" ]] && exit 0

REGISTRY=$(cat "$REGISTRY_PATH")
PROMPT_LOWER=$(printf '%s' "$USER_PROMPT" | tr '[:upper:]' '[:lower:]')

# ── Intent classification ────────────────────────────────────────────────────
classify_intent() {
  local best="OTHER" best_score=0
  local categories
  categories=$(printf '%s' "$REGISTRY" | jq -r '.intent_categories | keys[]')
  for cat in $categories; do
    local score=0
    local keywords
    keywords=$(printf '%s' "$REGISTRY" | jq -r ".intent_categories.\"$cat\".keywords[]")
    while IFS= read -r kw; do
      [[ "$PROMPT_LOWER" == *"$kw"* ]] && ((score++)) || true
    done <<< "$keywords"
    local modifier
    modifier=$(printf '%s' "$REGISTRY" | jq -r ".intent_categories.\"$cat\".workflow_modifier // 0")
    local adj
    adj=$(echo "$score + $modifier" | bc -l 2>/dev/null || echo "$score")
    if (( $(echo "$adj > $best_score" | bc -l 2>/dev/null || echo 0) )); then
      best_score=$adj; best=$cat
    fi
  done
  echo "$best"
}

# ── Domain detection ─────────────────────────────────────────────────────────
detect_domain() {
  local best="general" best_score=0
  local domains
  domains=$(printf '%s' "$REGISTRY" | jq -r '.domain_indicators | keys[]')
  for domain in $domains; do
    local score=0
    local indicators
    indicators=$(printf '%s' "$REGISTRY" | jq -r ".domain_indicators.\"$domain\"[]")
    while IFS= read -r ind; do
      [[ "$PROMPT_LOWER" == *"$ind"* ]] && ((score++)) || true
    done <<< "$indicators"
    (( score > best_score )) && { best_score=$score; best=$domain; }
  done
  echo "$best"
}

# ── Complexity scoring ───────────────────────────────────────────────────────
calculate_complexity() {
  local intent="$1" complexity
  case "$intent" in
    FIX_BUG)      complexity=0.30 ;;
    ADD_FEATURE)  complexity=0.35 ;;
    MODIFY)       complexity=0.25 ;;
    EXPLAIN)      complexity=0.10 ;;
    RESEARCH)     complexity=0.15 ;;
    TEST)         complexity=0.30 ;;
    COMMIT)       complexity=0.10 ;;
    *)            complexity=0.20 ;;
  esac

  local kw
  for kw in $(printf '%s' "$REGISTRY" | jq -r '.complexity_factors.keywords.high[]' 2>/dev/null); do
    [[ "$PROMPT_LOWER" == *"$kw"* ]] && complexity=$(echo "$complexity + 0.15" | bc -l)
  done
  for kw in $(printf '%s' "$REGISTRY" | jq -r '.complexity_factors.keywords.medium[]' 2>/dev/null); do
    [[ "$PROMPT_LOWER" == *"$kw"* ]] && complexity=$(echo "$complexity + 0.05" | bc -l)
  done
  for kw in $(printf '%s' "$REGISTRY" | jq -r '.complexity_factors.keywords.low[]' 2>/dev/null); do
    [[ "$PROMPT_LOWER" == *"$kw"* ]] && complexity=$(echo "$complexity - 0.10" | bc -l)
  done

  # Clamp [0.1, 1.0]
  (( $(echo "$complexity < 0.1" | bc -l) )) && complexity=0.10
  (( $(echo "$complexity > 1.0" | bc -l) )) && complexity=1.00

  printf "%.2f" "$complexity"
}

determine_workflow() {
  local c="$1"
  if   (( $(echo "$c < 0.20" | bc -l) )); then echo "quick"
  elif (( $(echo "$c < 0.40" | bc -l) )); then echo "standard"
  elif (( $(echo "$c < 0.60" | bc -l) )); then echo "careful"
  else echo "full"
  fi
}

# ── Main ─────────────────────────────────────────────────────────────────────
INTENT=$(classify_intent)
DOMAIN=$(detect_domain)
COMPLEXITY=$(calculate_complexity "$INTENT")
WORKFLOW=$(determine_workflow "$COMPLEXITY")

mkdir -p "$DS_DIR"
jq -n \
  --arg sid "$SESSION_ID" \
  --arg prompt "$USER_PROMPT" \
  --arg intent "$INTENT" \
  --arg domain "$DOMAIN" \
  --argjson complexity "$COMPLEXITY" \
  --arg workflow "$WORKFLOW" \
  --arg ts "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
  '{
    version:"3.0.0", session_id:$sid, timestamp:$ts,
    task:{original_prompt:$prompt, intent:$intent, domain:$domain, complexity:$complexity},
    workflow:{type:$workflow, current_phase:"QUEUED", progress:0}
  }' > "$STATE_PATH"

# Output to Claude context (stdout becomes system message)
echo "[DEV-STACKS] $INTENT | $DOMAIN | complexity: $COMPLEXITY"
case "$WORKFLOW" in
  quick)    echo "Workflow: quick — handle directly, no agents needed" ;;
  standard) echo "Workflow: standard — invoke /dev-stacks:run (thinker → builder)" ;;
  careful)  echo "Workflow: careful — invoke /dev-stacks:run (thinker → builder → reviewer)" ;;
  full)     echo "Workflow: full — invoke /dev-stacks:team (lead + parallel reviewers)" ;;
esac

exit 0
