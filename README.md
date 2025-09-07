[![Netlify Status](https://api.netlify.com/api/v1/badges/8cfa8785-8df8-4aad-ad35-8f1c790b8baf/deploy-status)](https://app.netlify.com/sites/spectrumsyntax/deploys)

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

8) Push changes with the helper script:
   ```bash
   python3 git_push.py -m "Your message"
   ```
   See more options in the [Git push helper](#git-push-helper) section (includes IPv4/IPv6 flags for reliable SSH when iCloud Private Relay is enabled).

## Deployment

This site relies on custom Jekyll plugins, so GitHub Pages cannot build it directly. The project is deployed to Netlify using the configuration in [`netlify.toml`](netlify.toml). Pushing to the main branch triggers a production build.

To host the site elsewhere, run `bundle exec jekyll build` and upload the generated `_site` directory to your provider.

### Images and WebP

- Local WebP generation
  - Run `bundle exec rake webp` to generate `.webp` variants for images under `assets/rocks/` and `assets/tumbling/`.
  - Requires Python 3 and Pillow. If missing, install with `pip3 install Pillow`.
  - Safe to run repeatedly; only converts new/changed files.

- Netlify build
  - Netlify runs the WebP step automatically before building Jekyll (`bundle exec rake webp && bundle exec jekyll build --trace`).

- Template behaviour
  - Templates prefer WebP for local images via a `<picture>` source and fall back to the original JPEG/PNG.
  - External images (e.g., Wikimedia) are used as-is.

- Placeholders
  - Category placeholders live under `assets/rocks/` and are auto‑selected if a thumbnail is missing or fails to load:
    - `placeholder-igneous.webp|jpg`, `placeholder-metamorphic.webp|jpg`, `placeholder-sedimentary.webp|jpg`, `placeholder-mineral.webp|jpg`, and default `placeholder.webp|jpg`.
  - Replace these files with your own artwork to customize the look.

## Change summaries

Generate summaries locally and in CI for easier PR descriptions and reviews.

- Local pre-push summary
  - Enable hooks once per clone:
    ```bash
    git config core.hooksPath .githooks
    ```
    - Pre-commit: auto-generates WebP for staged images in `assets/rocks/` and `assets/tumbling/`, then stages the resulting `.webp` files.
    - Pre-push: warns if any local images are missing `.webp` siblings, and prints a Markdown change summary for easy PR/push notes.
  - On every push, a Markdown summary prints to the console and is saved to `.git/last_push_summary.md`.
  - You can also run manually for any range:
    ```bash
    scripts/changes_summary.sh <base> <head>
    ```

- GitHub Actions
  - PR summary comment: see `.github/workflows/pr-summary.yml` — posts/updates a comment with commits and file changes on each PR update.
  - Push summary check: see `.github/workflows/push-summary.yml` — adds a “Change Summary” check run to each push with the same details.

## Git push helper

Use the repository’s helper script to stage, commit, rebase, and push with sensible defaults.

- Run a push with a message
  ```bash
  python3 git_push.py -m "Update"
  ```
  - Stages all changes, commits if anything is staged, fetches, rebases onto the upstream if set, and pushes. If there’s no upstream yet, it pushes with `-u origin <branch>`.

- Rebase flow with autostash
  ```bash
  python3 git_push.py --rebase-flow --autostash -m "Refactor navigation"
  ```

- Remote/branch overrides
  ```bash
  python3 git_push.py --remote origin --branch main -m "Sync"
  ```

- Network transport flags
  - By default, the script prefers IPv4 for SSH to reduce iCloud Private Relay/IPv6 quirks: it sets `GIT_SSH_COMMAND=ssh -4` if not already defined.
  - Force IPv4 explicitly: `python3 git_push.py --force-ipv4`
  - Force IPv6 explicitly: `python3 git_push.py --force-ipv6`

- GitHub + iCloud Private Relay
  - For the most reliable SSH connectivity, use port 443 and prefer IPv4 via `~/.ssh/config`:
    ```
    Host github.com
      HostName ssh.github.com
      Port 443
      AddressFamily inet
    ```
  - If your remote uses HTTPS, consider switching to SSH:
    ```bash
    git remote set-url origin git@github.com:<OWNER>/<REPO>.git
    ```

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

Source code is available under the [MIT license](LICENSE).
