#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

bot_config_file="${XDG_CONFIG_HOME:-${HOME}/.config}/personal-exploration-wecom-gateway/bot.env"

if [[ ! -f "${bot_config_file}" ]]; then
  echo "Missing ${bot_config_file}. Run ./scripts/setup-bot.sh first." >&2
  exit 1
fi

set -a
# shellcheck disable=SC1091
source "${bot_config_file}"
set +a

export WECOM_TRANSPORT=bot
export MOCK_WECOM=false
export MOCK_CODEX=false
export CODEX_BIN="$(./scripts/find-codex.sh)"
export CODEX_CWD="/mnt/e/Project/LMK/个人探索工作空间"
export STATE_DB="./data/personal-exploration-bot.db"
export PROGRESS_DELAY_SECONDS="${PROGRESS_DELAY_SECONDS:-8}"

echo "Using Codex CLI: ${CODEX_BIN}"
echo "Connecting to Enterprise WeChat bot long connection..."
exec .venv/bin/python -m uvicorn app.main:app --host 127.0.0.1 --port 8788
