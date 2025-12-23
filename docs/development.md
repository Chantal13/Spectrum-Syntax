# Development Guide

This guide covers the day-to-day workflow for local development.

## Starting the Development Server

Run Jekyll's built-in server for live preview:

```bash
bundle exec jekyll serve
```

The site will be available at http://localhost:4000 and will auto-reload when you make changes.

## Building the Site

To generate static files without starting a server:

```bash
bundle exec jekyll build
```

The output is written to the `_site/` directory.

## Testing

### Run Test Suite

```bash
bundle exec rake test
```

### Check for Missing Assets

Scans front matter for image paths and fails if any referenced file is missing:

```bash
ruby scripts/check_assets.rb
```

### Check Built-Site Links

Validates internal links after building the site:

```bash
python3 scripts/check_site_links.py
```

## WebP Image Generation

Generate `.webp` variants for images under `assets/rocks/` and `assets/tumbling/`:

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
