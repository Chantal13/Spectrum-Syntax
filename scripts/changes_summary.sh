#!/usr/bin/env bash
set -uo pipefail

# Generate a Markdown summary of changes between two SHAs or refs.
# Usage:
#   scripts/changes_summary.sh <base> <head>
# If run from a pre-push hook, it will read ref updates from stdin and
# fall back to the current branch's upstream if none provided.

md_escape() { sed 's/\/\\/g; s/\*/\\*/g; s/_/\\_/g; s/`/\\`/g'; }

resolve_range() {
  local base="$1" head="$2"
  if [[ -n "${base:-}" && -n "${head:-}" ]]; then
    echo "$base" "$head"; return 0
  fi

  # Try to read from stdin (pre-push provides lines of: local_ref local_sha remote_ref remote_sha)
  if ! tty -s && read -r lref lsha rref rsha; then
    : # noop
  fi

  # Prefer SHAs if they look valid
  if [[ "${lsha:-}" =~ ^[0-9a-f]{40}$ && "${rsha:-}" =~ ^[0-9a-f]{40}$ ]]; then
    echo "$rsha" "$lsha"; return 0
  fi

  # Fallback to upstream tracking
  local upstream
  if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @\{u\} 2>/dev/null); then
    echo "$upstream" "HEAD"; return 0
  fi

  # Last resort: previous commit
  echo "HEAD~1" "HEAD"
}

main() {
  local base="${1:-}" head="${2:-}"
  read -r base head < <(resolve_range "$base" "$head")

  # Ensure git repo
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "Not a git repo" >&2; exit 0; }

  # Collect metadata
  local title
  title=$(printf "Changes: %s..%s" "$base" "$head")
  local branch user remote
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")
  user=$(git config user.name 2>/dev/null || echo "")
  remote=$(git remote get-url --push origin 2>/dev/null || echo "origin")

  # Commits list
  local commits
  commits=$(git log --pretty=format:'- %h %s (%an, %ad)' --date=short "$base..$head" 2>/dev/null || true)

  # File changes
  mapfile -t lines < <(git diff --name-status "$base..$head" 2>/dev/null || true)
  declare -a adds mods dels renames
  for ln in "${lines[@]}"; do
    status=${ln%%$'\t'*}
    path=${ln#*$'\t'}
    case "$status" in
      A) adds+=("$path") ;;
      M) mods+=("$path") ;;
      D) dels+=("$path") ;;
      R*) # rename format: R100\told\tnew
          old=${path%%$'\t'*}; new=${path#*$'\t'}; renames+=("$old → $new") ;;
    esac
  done

  # Build markdown
  {
    echo "**$title**"
    echo
    echo "- Branch: \"`git rev-parse --abbrev-ref HEAD`\
      (pushing as ${user})"
    echo "- Range: \"`git rev-parse --short "$base"`\
..\
\
`git rev-parse --short "$head"`\
      ($remote)"
    echo
    if [[ -n "$commits" ]]; then
      echo "**Commits**"
      echo "$commits" | md_escape
      echo
    fi
    echo "**Files Changed**"
    [[ ${#adds[@]} -gt 0 ]] && { echo "- Added:"; for f in "${adds[@]}"; do echo "  - \"`echo "$f" | md_escape`\""; done; }
    [[ ${#mods[@]} -gt 0 ]] && { echo "- Modified:"; for f in "${mods[@]}"; do echo "  - \"`echo "$f" | md_escape`\""; done; }
    [[ ${#dels[@]} -gt 0 ]] && { echo "- Deleted:"; for f in "${dels[@]}"; do echo "  - \"`echo "$f" | md_escape`\""; done; }
    [[ ${#renames[@]} -gt 0 ]] && { echo "- Renamed:"; for f in "${renames[@]}"; do echo "  - \"`echo "$f" | md_escape`\""; done; }
  } | tee \
    "$(git rev-parse --git-dir)/last_push_summary.md" >/dev/null

  # Also print a copy to stdout for hook usage
  cat "$(git rev-parse --git-dir)/last_push_summary.md"
  echo
  echo "(Saved to $(git rev-parse --git-dir)/last_push_summary.md)"
}

main "$@"

