#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

export CODEX_BIN="$(./scripts/find-codex.sh)"
export MOCK_WECOM=true
export MOCK_CODEX=false
export DEV_API_TOKEN="local-development-token"
export STATE_DB="./data/personal-exploration-local-codex.db"
export CODEX_CWD="/mnt/e/Project/LMK/个人探索工作空间"
export PROGRESS_DELAY_SECONDS="${PROGRESS_DELAY_SECONDS:-8}"

echo "Using Codex CLI: ${CODEX_BIN}"
exec .venv/bin/python -m uvicorn app.main:app --host 127.0.0.1 --port 8788
