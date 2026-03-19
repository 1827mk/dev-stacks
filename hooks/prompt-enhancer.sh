#!/bin/bash
# Dev-Stacks Prompt Enhancer v2.0.0
# Entry point for full-feature plugin architecture

set -euo pipefail

# Configuration
REGISTRY_PATH="${CLAUDE_PLUGIN_ROOT:-.}/../.dev-stacks/registry.json"
STATE_PATH="${CLAUDE_PLUGIN_ROOT:-.}/../.dev-stacks/state.json"
MAX_OUTPUT_LINES=3

# Read JSON input from stdin
INPUT=$(cat)
USER_PROMPT=$(echo "$INPUT" | jq -r '.user_prompt // ""')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

# Skip slash commands
if [[ "$USER_PROMPT" == /* ]]; then
    exit 0
fi

# Skip empty prompts
if [[ -z "$USER_PROMPT" || ${#USER_PROMPT} -lt 2 ]]; then
    exit 0
fi

# Check registry exists
if [[ ! -f "$REGISTRY_PATH" ]]; then
    exit 0
fi

# Read registry
REGISTRY=$(cat "$REGISTRY_PATH")

# Convert prompt to lowercase for matching
PROMPT_LOWER=$(echo "$USER_PROMPT" | tr '[:upper:]' '[:lower:]')

# ============================================
# INTENT CLASSIFICATION
# ============================================
classify_intent() {
    local prompt="$1"
    local best_intent="OTHER"
    local best_score=0

    # Get intent categories
    local categories=$(echo "$REGISTRY" | jq -r '.intent_categories | keys[]')

    for category in $categories; do
        local score=0
        local keywords=$(echo "$REGISTRY" | jq -r ".intent_categories.$category.keywords[]")

        for keyword in $keywords; do
            if [[ "$PROMPT_LOWER" == *"$keyword"* ]]; then
                ((score++))
            fi
        done

        # Apply workflow modifier
        local modifier=$(echo "$REGISTRY" | jq -r ".intent_categories.$category.workflow_modifier // 0")
        local adjusted_score=$(echo "$score + $modifier" | bc -l 2>/dev/null || echo "$score")

        if (( $(echo "$adjusted_score > $best_score" | bc -l 2>/dev/null || echo "0") )); then
            best_score=$adjusted_score
            best_intent="$category"
        fi
    done

    echo "$best_intent"
}

# ============================================
# DOMAIN DETECTION
# ============================================
detect_domain() {
    local prompt="$1"
    local best_domain="general"
    local best_score=0

    local domains=$(echo "$REGISTRY" | jq -r '.domain_indicators | keys[]')

    for domain in $domains; do
        local score=0
        local indicators=$(echo "$REGISTRY" | jq -r ".domain_indicators.$domain[]")

        for indicator in $indicators; do
            if [[ "$PROMPT_LOWER" == *"$indicator"* ]]; then
                ((score++))
            fi
        done

        if (( $score > $best_score )); then
            best_score=$score
            best_domain="$domain"
        fi
    done

    echo "$best_domain"
}

# ============================================
# COMPLEXITY CALCULATION
# ============================================
calculate_complexity() {
    local prompt="$1"
    local intent="$2"
    local domain="$3"
    local complexity=0.2

    # Base complexity from intent
    case "$intent" in
        "FIX_BUG") complexity=0.3 ;;
        "ADD_FEATURE") complexity=0.35 ;;
        "MODIFY") complexity=0.25 ;;
        "EXPLAIN") complexity=0.1 ;;
        "RESEARCH") complexity=0.15 ;;
        "TEST") complexity=0.3 ;;
        "COMMIT") complexity=0.1 ;;
        *) complexity=0.2 ;;
    esac

    # Adjust for high-complexity keywords
    local high_keywords=$(echo "$REGISTRY" | jq -r '.complexity_keywords.high[]')
    for keyword in $high_keywords; do
        if [[ "$PROMPT_LOWER" == *"$keyword"* ]]; then
            complexity=$(echo "$complexity + 0.15" | bc -l)
        fi
    done

    # Adjust for medium-complexity keywords
    local med_keywords=$(echo "$REGISTRY" | jq -r '.complexity_keywords.medium[]')
    for keyword in $med_keywords; do
        if [[ "$PROMPT_LOWER" == *"$keyword"* ]]; then
            complexity=$(echo "$complexity + 0.05" | bc -l)
        fi
    done

    # Adjust for low-complexity keywords
    local low_keywords=$(echo "$REGISTRY" | jq -r '.complexity_keywords.low[]')
    for keyword in $low_keywords; do
        if [[ "$PROMPT_LOWER" == *"$keyword"* ]]; then
            complexity=$(echo "$complexity - 0.1" | bc -l)
        fi
    done

    # Clamp between 0.1 and 1.0
    if (( $(echo "$complexity < 0.1" | bc -l) )); then
        complexity=0.1
    elif (( $(echo "$complexity > 1.0" | bc -l) )); then
        complexity=1.0
    fi

    # Round to 2 decimal places
    printf "%.2f" "$complexity"
}

# ============================================
# WORKFLOW DETERMINATION
# ============================================
determine_workflow() {
    local complexity="$1"

    if (( $(echo "$complexity < 0.2" | bc -l) )); then
        echo "quick"
    elif (( $(echo "$complexity < 0.4" | bc -l) )); then
        echo "standard"
    elif (( $(echo "$complexity < 0.6" | bc -l) )); then
        echo "careful"
    else
        echo "full"
    fi
}

# ============================================
# STATE WRITING
# ============================================
write_state() {
    local session_id="$1"
    local prompt="$2"
    local intent="$3"
    local domain="$4"
    local complexity="$5"
    local workflow="$6"

    mkdir -p "$(dirname "$STATE_PATH")"

    jq -n \
        --arg sid "$session_id" \
        --arg prompt "$prompt" \
        --arg intent "$intent" \
        --arg domain "$domain" \
        --argjson complexity "$complexity" \
        --arg workflow "$workflow" \
        --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
        '{
            version: "1.0.0",
            session_id: $sid,
            timestamp: $timestamp,
            task: {
                original_prompt: $prompt,
                intent: $intent,
                domain: $domain,
                complexity: $complexity
            },
            workflow: {
                type: $workflow,
                current_phase: "QUEUED",
                progress: 0
            }
        }' > "$STATE_PATH"
}

# ============================================
# MAIN EXECUTION
# ============================================
main() {
    # Step 1: Classify intent
    local intent=$(classify_intent "$USER_PROMPT")

    # Step 2: Detect domain
    local domain=$(detect_domain "$USER_PROMPT")

    # Step 3: Calculate complexity
    local complexity=$(calculate_complexity "$USER_PROMPT" "$intent" "$domain")

    # Step 4: Determine workflow
    local workflow=$(determine_workflow "$complexity")

    # Step 5: Write state
    write_state "$SESSION_ID" "$USER_PROMPT" "$intent" "$domain" "$complexity" "$workflow"

    # Step 6: Output (2-3 lines max)
    echo "[DEV-STACKS] $intent | $domain | complexity: $complexity"
    echo "Workflow: $workflow | Invoke: /dev-stacks:$workflow"

    # Add tool suggestions for certain workflows
    if [[ "$workflow" != "quick" ]]; then
        local tools=$(echo "$REGISTRY" | jq -r ".workflow_tools.$intent // [] | join(\", \")")
        if [[ -n "$tools" && "$tools" != "null" ]]; then
            echo "Tools: $tools"
        fi
    fi
}

main
exit 0
