[![Netlify Status](https://api.netlify.com/api/v1/badges/8cfa8785-8df8-4aad-ad35-8f1c790b8baf/deploy-status)](https://app.netlify.com/sites/spectrumsyntax/deploys)

# Spectrum Syntax

A personal digital garden built with Jekyll, featuring Roam-style bidirectional links, automatic backlinks, hover previews, and an interactive notes graph.

**Live site:** https://spectrumsyntax.netlify.app/

Based on Maxime Vaillancourt's [digital-garden-jekyll-template](https://github.com/maximevaillancourt/digital-garden-jekyll-template).

## Features

- Roam-style double bracket links
- Automatic backlinks between notes
- Hover link previews
- Interactive notes graph
- Simple, responsive design
- Markdown or HTML notes

## Quick Start

```bash
# Install dependencies
make install

# Start development server
make serve
```

Visit http://localhost:4000

**See all available commands:** `make help`

## Documentation

- **[Setup Guide](docs/setup.md)** - Installation and dependencies
- **[Development Guide](docs/development.md)** - Local development workflow
- **[Deployment Guide](docs/deployment.md)** - Production deployment
- **[Content Guide](docs/content-guide.md)** - Adding and organizing content
- **[Scripts Documentation](docs/scripts.md)** - Available automation tools
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions

## Common Commands

Use `make` for simplified workflow:

```bash
make serve          # Start development server
make build          # Build site
make test           # Run tests
make webp           # Generate WebP images
make check          # Run all checks
make clean          # Clean build artifacts
make help           # Show all commands
```

Or use the underlying commands directly:

```bash
bundle exec jekyll serve
bundle exec jekyll build
bundle exec rake test
bundle exec rake webp
ruby scripts/check_assets.rb
python3 scripts/git_push.py -m "Your commit message"
```

## License

Source code is available under the [MIT license](LICENSE).
