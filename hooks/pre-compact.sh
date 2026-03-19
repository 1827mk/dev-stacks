#!/bin/bash
# Dev-Stacks PreCompact Hook
# Backup session state before context compaction

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract info
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

# Dev-Stacks directories
DEV_STACKS_DIR="$CWD/.dev-stacks"
BACKUP_DIR="$DEV_STACKS_DIR/backups"
LOGS_DIR="$DEV_STACKS_DIR/logs"
ARCHIVE_DIR="$LOGS_DIR/archive"

# Create backup directories
mkdir -p "$BACKUP_DIR"
mkdir -p "$ARCHIVE_DIR"

# Timestamp for backup files
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

# Backup checkpoint
CHECKPOINT_FILE="$DEV_STACKS_DIR/checkpoint.json"
if [[ -f "$CHECKPOINT_FILE" ]]; then
    cp "$CHECKPOINT_FILE" "$BACKUP_DIR/checkpoint-$TIMESTAMP.json"
fi

# Backup DNA
DNA_FILE="$DEV_STACKS_DIR/dna.json"
if [[ -f "$DNA_FILE" ]]; then
    cp "$DNA_FILE" "$BACKUP_DIR/dna-$TIMESTAMP.json"
fi

# Archive session logs (handle case where no files exist)
shopt -s nullglob
log_files=("$LOGS_DIR"/session-*.log)
shopt -u nullglob

for log_file in "${log_files[@]}"; do
    if [[ -f "$log_file" ]]; then
        cp "$log_file" "$ARCHIVE_DIR/"
    fi
done

echo "💾 [DEV-STACKS] Session backed up before compaction"

exit 0
