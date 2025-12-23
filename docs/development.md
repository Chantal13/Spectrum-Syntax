# Development Guide

This guide covers the day-to-day workflow for local development.

## Quick Reference

Use the Makefile for simplified commands:

```bash
make serve          # Start development server
make build          # Build the site
make test           # Run test suite
make webp           # Generate WebP images
make check          # Run all checks
make clean          # Clean build artifacts
make help           # Show all available commands
```

See full command list with `make help`.

## Starting the Development Server

Using Make:
```bash
make serve
```

Or directly:
```bash
bundle exec jekyll serve
```

The site will be available at http://localhost:4000 and will auto-reload when you make changes.

## Building the Site

Using Make:
```bash
make build
```

Or directly:
```bash
bundle exec jekyll build
```

The output is written to the `_site/` directory.

## Testing

### Run Test Suite

Using Make:
```bash
make test
```

Or directly:
```bash
bundle exec rake test
```

### Run All Checks

Using Make:
```bash
make check          # Run all checks
make check-assets   # Check for missing assets only
make check-links    # Check for broken links only
make check-webp     # Check for missing WebP variants
```

Or run scripts directly:
```bash
ruby scripts/check_assets.rb
python3 scripts/check_site_links.py
python3 scripts/check_webp_siblings.py
```

## WebP Image Generation

Generate `.webp` variants for images under `assets/rocks/` and `assets/tumbling/`:

Using Make:
```bash
make webp
```

Or directly:
```bash
bundle exec rake webp
```

Requirements:
- Python 3
- Pillow (`pip3 install Pillow`)

The task is safe to run repeatedly and only converts new or changed files.

## Git Hooks

Enable Git hooks for automatic WebP generation and change summaries:

```bash
git config core.hooksPath .githooks
```

### Pre-commit Hook

Auto-generates WebP for staged images in `assets/rocks/` and `assets/tumbling/`, then stages the resulting `.webp` files.

### Pre-push Hook

- Warns if any local images are missing `.webp` siblings
- Prints a Markdown change summary for easy PR/push notes
- Saves summary to `.git/last_push_summary.md`

## Change Summaries

### Local Summary

Generate a summary for any commit range:

```bash
scripts/changes_summary.sh <base> <head>
```

### CI Summaries

- **PR summary**: `.github/workflows/pr-summary.yml` posts/updates a comment on each PR
- **Push summary**: `.github/workflows/push-summary.yml` adds a check run with change details

## Git Push Helper

Use the repository's helper script for a streamlined push workflow:

### Basic Usage

```bash
python3 scripts/git_push.py -m "Update"
```

This will:
1. Stage all changes
2. Commit if anything is staged
3. Fetch from remote
4. Rebase onto upstream (if set)
5. Push to remote

### Advanced Options

Rebase flow with autostash:
```bash
python3 scripts/git_push.py --rebase-flow --autostash -m "Refactor navigation"
```

Override remote/branch:
```bash
python3 scripts/git_push.py --remote origin --branch main -m "Sync"
```

### Network Configuration

By default, the script prefers IPv4 for SSH to reduce iCloud Private Relay/IPv6 quirks.

Force IPv4 explicitly:
```bash
python3 scripts/git_push.py --force-ipv4
```

Force IPv6 explicitly:
```bash
python3 scripts/git_push.py --force-ipv6
```

### GitHub + iCloud Private Relay

For reliable SSH connectivity, configure `~/.ssh/config`:

```
Host github.com
  HostName ssh.github.com
  Port 443
  AddressFamily inet
```

Switch HTTPS remote to SSH:
```bash
git remote set-url origin git@github.com:<OWNER>/<REPO>.git
```

## Next Steps

- See [Content Guide](content-guide.md) for adding and organizing content
- See [Deployment Guide](deployment.md) for production deployment
