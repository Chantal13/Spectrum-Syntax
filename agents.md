# Agent Guidelines

This repository uses Codex CLI/agents to automate changes. After any change that affects the live site, always confirm the deployment succeeded and the change is visible.

## Always Confirm Live Deploys

- Fetch the live base URL in `_config.yml:url` (currently `https://spectrumsyntax.netlify.app`).
- After pushing to `main`, verify:
  - Key pages return HTTP 200 (e.g., `/`, `/rockhounding/`, `/logs/`).
  - New/changed assets return HTTP 200 (images, CSS/JS) and appear in the HTML.
  - Page markup reflects your change (e.g., new links, `<picture>` sources for WebP, etc.).
- If the deploy is not yet live, retry for a few minutes or check Netlify deploy logs.

### Quick check script

```
BASE="https://spectrumsyntax.netlify.app"
# Pages
for p in / \
         /rockhounding/ \
         /logs/ \
         /rockhounding/tumbling/ \
         /rockhounding/field-log/; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE$p")
  echo "$p -> $code"
done
# Example assets (replace as needed)
for a in \
  /assets/rockhounding/thumbs/rocks-and-minerals.webp \
  /assets/rockhounding/thumbs/guides.webp; do
  echo -n "$a -> "; curl -sI "$BASE$a" | sed -n '1p; /Content-Type/p; /Content-Length/p'
done
```

### When to escalate

- If deploy fails on CI: open the failing workflow, read the logs, and fix the workflow or dependency versions.
- If Netlify deploy fails: check the Netlify dashboard for build logs and errors.
- If the live site caches old assets, add a cache‑busting query (the site already appends `?v=timestamp` for many assets).

## Style of Changes

- Keep changes focused and minimal; don’t reformat unrelated files.
- Prefer small, descriptive commits.
- Update docs when behavior changes that affects users or editors.

```
Commit message example: "Logs page: unify tables and add type pills; confirm live deploy."
```
