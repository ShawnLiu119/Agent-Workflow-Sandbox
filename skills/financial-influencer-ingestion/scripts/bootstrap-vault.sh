#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /path/to/obsidian/vault" >&2
  exit 2
fi

target_vault=$1
skill_root=$(cd "$(dirname "$0")/.." && pwd)
workflow_root="${target_vault%/}/Financial Influencers"

mkdir -p \
  "$workflow_root/Sources/X" \
  "$workflow_root/Digests/Daily" \
  "$workflow_root/Digests/Weekly" \
  "$workflow_root/System"

if [[ ! -e "$workflow_root/System/influencer-watchlist.yaml" ]]; then
  cp "$skill_root/config/influencer-watchlist.yaml" "$workflow_root/System/influencer-watchlist.yaml"
fi

if [[ ! -e "$workflow_root/System/financial-influencer-ledger.json" ]]; then
  cp "$skill_root/templates/financial-influencer-ledger.json" "$workflow_root/System/financial-influencer-ledger.json"
fi

if [[ ! -e "$workflow_root/投资短报.md" ]]; then
  printf '# 投资短报\n\n![[Digests/投资短报-最新]]\n' > "$workflow_root/投资短报.md"
fi

echo "Initialized: $workflow_root"
