# Scripts Documentation

This document describes the available scripts for automating common tasks.

## Asset Management

### `scripts/check_assets.rb`

Scans front matter for image paths and validates that all referenced files exist.

**Usage:**
```bash
ruby scripts/check_assets.rb
```

**Purpose:** Prevents broken images by detecting missing asset files before deployment.

**Exit code:** Fails if any referenced file is missing.

---

### `scripts/make_webp.py`

Generates `.webp` variants for images under `assets/rocks/` and `assets/tumbling/`.

**Usage:**
```bash
python3 scripts/make_webp.py
# OR via Rake:
bundle exec rake webp
# OR via Make:
make webp
```

**Requirements:**
- Python 3
- Pillow (`pip3 install Pillow`)

**Features:**
- **Intelligent caching** - Tracks processed files in `.webp-cache.json`
- **Blazing fast** - < 5 seconds on repeat runs with no changes
- **Smart detection** - Uses modification time + file size to detect changes
- **Progress indicator** - Shows conversion progress for large batches
- Safe to run repeatedly
- Maintains original image quality (quality=78, method=6)

**Performance:**
- First run: Processes all images
- Subsequent runs with no changes: < 5 seconds (cache hit)
- Only new/changed images are converted

---

### `scripts/check_webp_siblings.py`

Checks if local images have corresponding `.webp` variants.

**Usage:**
```bash
python3 scripts/check_webp_siblings.py
```

**Purpose:** Warns about images missing WebP siblings, used in pre-push hook.

---

### `scripts/fetch_wiki_thumbnails.rb`

Fetches thumbnails from Wikimedia for rock/mineral entries.

**Usage:**
```bash
ruby scripts/fetch_wiki_thumbnails.rb
```

**Purpose:** Automates thumbnail downloads for rockhounding content.

## Link Validation

### `scripts/check_site_links.py`

Validates internal links in the built site.

**Usage:**
```bash
python3 scripts/check_site_links.py
```

**Prerequisites:** Run `bundle exec jekyll build` first to generate `_site/`.

**Purpose:** Detects broken internal links before deployment.

## Change Management

### `scripts/changes_summary.sh`

Generates Markdown summaries of commits and file changes.

**Usage:**
```bash
scripts/changes_summary.sh <base> <head>
```

**Examples:**
```bash
# Summary of changes between main and current branch
scripts/changes_summary.sh main HEAD

# Summary of last 5 commits
scripts/changes_summary.sh HEAD~5 HEAD
```

**Purpose:**
- Generate PR descriptions
- Create push summaries
- Review changes before deployment

**Output:** Saved to `.git/last_push_summary.md` during pre-push hook.

## Git Workflow

### `scripts/git_push.py`

Helper script for staging, committing, rebasing, and pushing.

**Basic usage:**
```bash
python3 scripts/git_push.py -m "Commit message"
```

**Options:**
- `--rebase-flow` - Use rebase workflow
- `--autostash` - Automatically stash/unstash changes
- `--remote <name>` - Override remote (default: origin)
- `--branch <name>` - Override branch
- `--force-ipv4` - Force IPv4 for SSH
- `--force-ipv6` - Force IPv6 for SSH

**Examples:**
```bash
# Standard push
python3 scripts/git_push.py -m "Update documentation"

# Rebase with autostash
python3 scripts/git_push.py --rebase-flow --autostash -m "Fix bug"

# Custom remote/branch
python3 scripts/git_push.py --remote upstream --branch develop -m "Merge changes"
```

**Features:**
- Stages all changes
- Commits if anything is staged
- Fetches from remote
- Rebases onto upstream (if set)
- Pushes to remote
- Sets upstream on first push

See [Development Guide](development.md#git-push-helper) for detailed configuration.

## Linting

### `scripts/canadian_english_lint.py`

Checks content for Canadian English spelling and style.

**Usage:**
```bash
python3 scripts/canadian_english_lint.py
```

**Purpose:** Maintains consistent Canadian English spelling across content.

## Deployment

### `scripts/trigger_netlify_deploy.sh`

Triggers a Netlify deployment via webhook.

**Usage:**
```bash
scripts/trigger_netlify_deploy.sh
```

**Prerequisites:** Requires Netlify webhook URL configuration.

---

### `scripts/verify-site.sh`

Runs verification checks on the built site.

**Usage:**
```bash
scripts/verify-site.sh
```

**Checks:**
- Asset availability
- Link validity
- Build integrity

## Testing

Tests are organized in `tests/unit/`. See [Development Guide](development.md#testing) for running the test suite.

**Run all tests:**
```bash
bundle exec rake test
```

**Test files:**
- `tests/unit/image_exists_filter_test.rb` - Tests for image existence filter
- `tests/unit/test_git_push.py` - Tests for git_push.py script

## Next Steps

- See [Development Guide](development.md) for using these scripts in your workflow
- See [Troubleshooting](troubleshooting.md) for common script issues
