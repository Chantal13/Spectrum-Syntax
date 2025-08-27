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

1. Install dependencies:
   ```bash
   bundle install
   ```
2. Build or serve the site locally:
   ```bash
   bundle exec jekyll serve
   # or
   bundle exec jekyll build
   ```
   The development server runs at http://localhost:4000.

3. Check for missing assets:
   ```bash
   ruby scripts/check_assets.rb
   ```
   The script scans front matter for image paths and fails if any referenced file is missing.

4. Run the test suite:
   ```bash
   bundle exec rake test
   ```

## Deployment

This site relies on custom Jekyll plugins, so GitHub Pages cannot build it directly. The project is deployed to Netlify using the configuration in [`netlify.toml`](netlify.toml). Pushing to the main branch triggers a production build.

To host the site elsewhere, run `bundle exec jekyll build` and upload the generated `_site` directory to your provider.

## Customization

- Add or edit notes in [`_notes/`](./_notes).
- Update pages in [`_pages/`](./_pages).
- Adjust global settings in [`_config.yml`](_config.yml).
- Tweak styles via `styles.scss` and the files under [`assets/`](./assets).

## License

Source code is available under the [MIT license](LICENSE.md).

