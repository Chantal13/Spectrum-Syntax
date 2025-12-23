# Deployment Guide

This guide covers deploying Spectrum Syntax to production.

## Netlify Deployment (Current)

The site is currently deployed to Netlify at https://spectrumsyntax.netlify.app/

### How It Works

This site uses custom Jekyll plugins, so GitHub Pages cannot build it directly. Netlify handles the build process using the configuration in [`netlify.toml`](../netlify.toml).

### Automatic Deployment

Pushing to the `main` branch triggers a production build automatically.

### Build Process

Netlify runs the following commands:

1. Generate WebP images: `bundle exec rake webp`
2. Build Jekyll site: `bundle exec jekyll build --trace`

The generated `_site` directory is then deployed.

## Alternative Hosting

To host the site elsewhere:

1. Build the site locally:
   ```bash
   bundle exec jekyll build
   ```

2. Upload the generated `_site` directory to your hosting provider

## Images and WebP

### Local WebP Generation

Run before building:
```bash
make webp
# OR
bundle exec rake webp
```

This generates `.webp` variants for images under:
- `assets/rocks/`
- `assets/tumbling/`

**Requirements:**
- Python 3
- Pillow (`pip3 install Pillow`)

**Intelligent Caching:**
- Uses `.webp-cache.json` to track processed files
- Only converts new or changed images (based on modification time + file size)
- First run: Processes all images (~same time as before)
- Subsequent runs: < 5 seconds when no changes
- Progress indicator shows conversion status
- Cache file automatically managed (in `.gitignore`)

### Netlify Build

Netlify automatically runs the WebP generation step before building Jekyll.

### Template Behavior

- Templates prefer WebP for local images via `<picture>` source tags
- Falls back to original JPEG/PNG if WebP is unavailable
- External images (e.g., Wikimedia) are used as-is

### Placeholders

Category placeholders live under `assets/rocks/` and are auto-selected if a thumbnail is missing or fails to load:

- `placeholder-igneous.webp|jpg`
- `placeholder-metamorphic.webp|jpg`
- `placeholder-sedimentary.webp|jpg`
- `placeholder-mineral.webp|jpg`
- `placeholder.webp|jpg` (default)

Replace these files with your own artwork to customize the look.

## Deployment Checklist

Before deploying:

- [ ] Run tests: `bundle exec rake test`
- [ ] Check for missing assets: `ruby scripts/check_assets.rb`
- [ ] Build locally: `bundle exec jekyll build`
- [ ] Check built-site links: `python3 scripts/check_site_links.py`
- [ ] Generate WebP images: `bundle exec rake webp`
- [ ] Review changes and commit
- [ ] Push to main branch

## Monitoring

Check deployment status:
- Netlify dashboard: https://app.netlify.com/sites/spectrumsyntax/deploys
- Status badge: [![Netlify Status](https://api.netlify.com/api/v1/badges/8cfa8785-8df8-4aad-ad35-8f1c790b8baf/deploy-status)](https://app.netlify.com/sites/spectrumsyntax/deploys)
