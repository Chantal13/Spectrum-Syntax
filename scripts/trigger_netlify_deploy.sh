#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${NETLIFY_BUILD_HOOK_URL:-}" ]]; then
  echo "NETLIFY_BUILD_HOOK_URL is not set. Create a Netlify Build Hook and export its URL." >&2
  echo "Netlify → Site settings → Build & deploy → Build hooks" >&2
  exit 2
fi

echo "Triggering Netlify build via build hook…"
curl -fsSL -X POST "$NETLIFY_BUILD_HOOK_URL" -H 'Content-Type: application/json' -d '{}'
echo
echo "Build hook triggered. Check Netlify deploys for progress."

