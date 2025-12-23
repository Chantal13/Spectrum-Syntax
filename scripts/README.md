# Scripts Directory

This directory contains utility scripts for development, testing, and deployment automation.

## Naming Conventions

Scripts follow these naming patterns:
- **`check_*.{py,rb}`** - Validation and sanity checks
- **`make_*.py`** - Generation and build tasks
- **`fetch_*.rb`** - Data retrieval scripts
- **`verify-*.sh`** - Post-deployment verification
- **Other** - Specific utility scripts

All scripts include:
- Shebang line (`#!/usr/bin/env {python3,bash,ruby}`)
- Execute permissions (`chmod +x`)
- Inline documentation

## Asset Management Scripts

### `check_assets.rb`

**Purpose:** Validates that all images referenced in front matter actually exist.

**Usage:**
```bash
ruby scripts/check_assets.rb
```

**Exit code:** Non-zero if any referenced file is missing.

**When to use:**
- Before committing changes
- In CI/CD pipeline
- When debugging broken images

---

### `check_webp_siblings.py`

**Purpose:** Warns if JPG/PNG images lack corresponding .webp variants.

**Usage:**
```bash
python3 scripts/check_webp_siblings.py
```

**Exit code:** Always 0 (non-fatal, warnings only)

**When to use:**
- Pre-push hook (automatic)
- Before deployment
- After adding new images

---

### `make_webp.py`

**Purpose:** Generates .webp variants for images in assets/rocks/ and assets/tumbling/.

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
- Pillow library (`pip3 install Pillow`)

**Features:**
- **Intelligent caching** - Uses `.webp-cache.json` to track processed files
- **Blazing fast** - < 5 seconds on subsequent runs when no changes
- **Smart detection** - Compares modification time + file size
- **Progress indicator** - Shows real-time conversion progress
- Idempotent - safe to run repeatedly
- Non-fatal if Pillow unavailable

**Performance:**
- First run: Processes all images (~same time as before)
- Subsequent runs with no changes: < 5 seconds (cache hit)
- Only converts new or modified images

**Cache management:**
- Cache stored in `.webp-cache.json` (in `.gitignore`)
- Automatically created and updated
- Safe to delete - will rebuild on next run

**When to use:**
- After adding new images
- Pre-commit hook (automatic)
- Before deployment

---

### `fetch_wiki_thumbnails.rb`

**Purpose:** Downloads thumbnails from Wikimedia for rock/mineral entries.

**Usage:**
```bash
ruby scripts/fetch_wiki_thumbnails.rb
```

**When to use:**
- Adding new rock/mineral content
- Updating existing thumbnails

## Link Validation Scripts

### `check_site_links.py`

**Purpose:** Scans generated _site/ for broken internal links and missing assets.

**Usage:**
```bash
bundle exec jekyll build  # First build the site
python3 scripts/check_site_links.py
```

**Exit code:** Non-zero if broken links found

**When to use:**
- After major structural changes
- Before deployment
- In CI/CD pipeline

## Content Quality Scripts

### `canadian_english_lint.py`

**Purpose:** Checks content for Canadian English spelling consistency.

**Usage:**
```bash
python3 scripts/canadian_english_lint.py
```

**Scans:** .md and .html files in content paths

**When to use:**
- Before committing content changes
- As part of code review

## Change Management Scripts

### `changes_summary.sh`

**Purpose:** Generates Markdown summaries of commits and file changes between refs.

**Usage:**
```bash
scripts/changes_summary.sh <base> <head>
```

**Examples:**
```bash
# Changes from main to current branch
scripts/changes_summary.sh main HEAD

# Last 5 commits
scripts/changes_summary.sh HEAD~5 HEAD

# Between specific commits
scripts/changes_summary.sh abc123 def456
```

**Output:** Markdown-formatted summary with:
- Commit list
- File change statistics
- Modified files grouped by type

**When to use:**
- Creating PR descriptions
- Pre-push review (automatic)
- Release notes

## Git Workflow Scripts

### `git_push.py`

**Purpose:** Streamlined workflow for staging, committing, rebasing, and pushing.

**Usage:**
```bash
python3 scripts/git_push.py -m "Commit message"
```

**Options:**
- `-m, --message` - Commit message (required)
- `--rebase-flow` - Use rebase workflow
- `--autostash` - Auto-stash uncommitted changes
- `--remote <name>` - Override remote (default: origin)
- `--branch <name>` - Override branch
- `--force-ipv4` - Force IPv4 for SSH
- `--force-ipv6` - Force IPv6 for SSH

**Examples:**
```bash
# Basic push
python3 scripts/git_push.py -m "Update docs"

# Rebase workflow with autostash
python3 scripts/git_push.py --rebase-flow --autostash -m "Fix bug"

# Custom remote/branch
python3 scripts/git_push.py --remote upstream --branch develop -m "Merge"
```

**Workflow:**
1. Stages all changes
2. Commits if anything staged
3. Fetches from remote
4. Rebases onto upstream (if set)
5. Pushes to remote
6. Sets upstream on first push

**Network configuration:**
- Prefers IPv4 by default (reduces iCloud Private Relay issues)
- Configurable via command-line flags

See [Development Guide](../docs/development.md#git-push-helper) for detailed usage.

## Deployment Scripts

### `trigger_netlify_deploy.sh`

**Purpose:** Triggers Netlify build via webhook.

**Usage:**
```bash
export NETLIFY_BUILD_HOOK_URL="https://api.netlify.com/build_hooks/..."
scripts/trigger_netlify_deploy.sh
```

**When to use:**
- Manual deployment trigger
- CI/CD integration
- Testing deployment pipeline

---

### `verify-site.sh`

**Purpose:** Verifies key URLs after deployment.

**Usage:**
```bash
BASE_URL=https://example.com scripts/verify-site.sh
```

**When to use:**
- Post-deployment smoke testing
- CI/CD verification step

## Script Dependencies

### Python Scripts
- **Python 3.x** required
- `make_webp.py` requires Pillow: `pip3 install Pillow`
- `test_git_push.py` requires pytest: `pip3 install pytest`

### Ruby Scripts
- **Ruby 3.2.1** recommended (see .ruby-version)
- Uses standard library only

### Shell Scripts
- **Bash 4+** recommended
- Standard Unix utilities (grep, sed, awk, etc.)

## Testing Scripts

Run the test suite:
```bash
bundle exec rake test
```

Test files are in `tests/unit/`:
- `tests/unit/test_git_push.py` - Tests for git_push.py

## Maintenance

### Adding New Scripts

When adding a new script:

1. **Add shebang line:**
   ```python
   #!/usr/bin/env python3
   ```

2. **Make executable:**
   ```bash
   chmod +x scripts/your_script.py
   ```

3. **Follow naming convention:**
   - `check_*.{py,rb}` for validation
   - `make_*.py` for generation
   - `fetch_*.rb` for data retrieval

4. **Add inline documentation:**
   - Purpose comment at top
   - Usage examples
   - Exit code behavior

5. **Update this README** with script details

6. **Update docs/scripts.md** if user-facing

### Script Organization

- Keep scripts in `scripts/` directory (consolidated as of issue #112)
- Git hooks remain in `.githooks/`
- Test files in `tests/unit/`

## Related Documentation

- [Development Guide](../docs/development.md) - Workflow using these scripts
- [Scripts Documentation](../docs/scripts.md) - Detailed user-facing docs
- [Troubleshooting](../docs/troubleshooting.md) - Common script issues
