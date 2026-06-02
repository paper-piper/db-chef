#!/usr/bin/env bash
set -euo pipefail

# ─── Configuration ────────────────────────────────────────────────────────────

HOST="${PGHOST:-127.0.0.1}"
PORT="${PGPORT:-6000}"
DB="${PGDATABASE:-db-chef}"
USER="${PGUSER:-db-chef}"
MIGRATIONS_DIR="$(dirname "$0")/migrations"

# ─── Run ──────────────────────────────────────────────────────────────────────

echo "Connecting to $USER@$HOST:$PORT/$DB"
echo "Running migrations from: $MIGRATIONS_DIR"
echo

files=$(ls "$MIGRATIONS_DIR"/*.sql 2>/dev/null | sort)

if [[ -z "$files" ]]; then
  echo "No .sql files found in $MIGRATIONS_DIR"
  exit 0
fi

for file in $files; do
  name=$(basename "$file")
  echo "→ $name"
  psql \
    --host="$HOST" \
    --port="$PORT" \
    --dbname="$DB" \
    --username="$USER" \
    --file="$file" \
    -v ON_ERROR_STOP=1 \
    --quiet
done

echo
echo "Done."
