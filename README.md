[![Netlify Status](https://api.netlify.com/api/v1/badges/8cfa8785-8df8-4aad-ad35-8f1c790b8baf/deploy-status)](https://app.netlify.com/sites/digital-garden-jekyll-template/deploys)

# Spectrum Syntax

Spectrum Syntax is a personal digital garden built with Jekyll. It is based on Maxime Vaillancourt's [digital-garden-jekyll-template](https://github.com/maximevaillancourt/digital-garden-jekyll-template); thanks to Maxime for sharing it.

https://spectrumsyntax.netlify.app/

## Features

- Roam-style double bracket links
- Automatic backlinks between notes
- Hover link previews
- Interactive notes graph
- Simple, responsive design
- Markdown or HTML notes

## Local setup

This project targets Ruby 3.2.1 and Bundler 2.7.1. On macOS, use rbenv for a smooth setup.

1) Install rbenv + ruby-build:
   ```bash
   brew install rbenv ruby-build
   ```

2) Install Ruby (from `.ruby-version`):
   ```bash
   rbenv install 3.2.1
   # If you hit macOS SDK/readline errors, try one of:
   #   RUBY_CONFIGURE_OPTS="--with-out-ext=readline" rbenv install 3.2.1
   #   rbenv install 3.3.5 && rbenv local 3.3.5
   # If OpenSSL isn’t detected:
   #   export OPENSSL_DIR="$(brew --prefix openssl@3)"
   #   export CPPFLAGS="-I$OPENSSL_DIR/include"
   #   export LDFLAGS="-L$OPENSSL_DIR/lib"
   ```

3) Use the Ruby version for this repo and install gems:
   ```bash
   rbenv local 3.2.1   # or `rbenv shell 3.2.1`
   gem install bundler:2.7.1
   bundle _2.7.1_ install
   ```

4) Build or serve the site locally:
   ```bash
   bundle exec jekyll serve
   # or
   bundle exec jekyll build
   ```
   The development server runs at http://localhost:4000.

5) Check for missing assets:
   ```bash
   ruby scripts/check_assets.rb
   ```
   The script scans front matter for image paths and fails if any referenced file is missing.

6) Check built-site links (after build):
   ```bash
   python3 scripts/check_site_links.py
   ```

7) Run the test suite:
   ```bash
   bundle exec rake test
   ```

## Deployment

This site relies on custom Jekyll plugins, so GitHub Pages cannot build it directly. The project is deployed to Netlify using the configuration in [`netlify.toml`](netlify.toml). Pushing to the main branch triggers a production build.

To host the site elsewhere, run `bundle exec jekyll build` and upload the generated `_site` directory to your provider.

## Change summaries

Generate summaries locally and in CI for easier PR descriptions and reviews.

- Local pre-push summary
  - Enable hooks once per clone:
    ```bash
    git config core.hooksPath .githooks
    ```
  - On every push, a Markdown summary prints to the console and is saved to `.git/last_push_summary.md`.
  - You can also run manually for any range:
    ```bash
    scripts/changes_summary.sh <base> <head>
    ```

- GitHub Actions
  - PR summary comment: see `.github/workflows/pr-summary.yml` — posts/updates a comment with commits and file changes on each PR update.
  - Push summary check: see `.github/workflows/push-summary.yml` — adds a “Change Summary” check run to each push with the same details.

## Customization

- Add or edit notes in [`_notes/`](./_notes).
- Update pages in [`_pages/`](./_pages).
- Adjust global settings in [`_config.yml`](_config.yml).
- Tweak styles via `styles.scss` and the files under [`assets/`](./assets).

### Content structure notes

- Rocks taxonomy
  - Rock pages live under `_notes/rockhounding/rocks/{igneous|metamorphic|sedimentary}/...`.
  - Minerals live under `_notes/rockhounding/rocks/minerals/...`.
  - Category landing pages are in `_pages/rockhounding/rocks/{igneous|metamorphic|sedimentary}/index.md`.
  - The interactive graph colours rock nodes by class (igneous/sedimentary/metamorphic) based on these paths. Keep new rock notes in the correct folder to get proper colouring.

- Redirects for legacy paths
  - Old URLs like `/rockhounding/rocks/category/{igneous|metamorphic|sedimentary}/` and top‑level rock pages (e.g., `/rockhounding/rocks/granite/`) now redirect to their new locations.
  - Redirect rules are defined in `netlify.toml`. Please update internal links to point to the new paths to avoid redirect hops.

- Administrative checklist
  - The tumbling log checklist lives at [`_pages/tumbling/log-checklist.md`](_pages/tumbling/log-checklist.md) (served at `/tumbling/log-checklist/`). Use it when adding or updating tumbling batch logs.

## License

Source code is available under the [MIT license](LICENSE.md).
