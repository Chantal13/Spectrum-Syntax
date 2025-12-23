# Content Guide

This guide covers adding and organizing content in Spectrum Syntax.

## Content Organization

### Notes

Add or edit notes in [`_notes/`](../_notes).

Notes support:
- Roam-style double bracket links: `[[Note Title]]`
- Automatic backlinks between notes
- Hover link previews
- Markdown or HTML formatting

### Pages

Update static pages in [`_pages/`](../_pages).

### Configuration

Adjust global settings in [`_config.yml`](../_config.yml).

### Styles

Tweak styles via:
- `styles.scss`
- Files under [`assets/`](../assets)

## Rocks Taxonomy

### Directory Structure

Rock and mineral pages follow a specific structure for proper categorization and graph coloring:

- **Igneous rocks:** `_notes/notes/rockhounding/rocks/igneous/...`
- **Metamorphic rocks:** `_notes/notes/rockhounding/rocks/metamorphic/...`
- **Sedimentary rocks:** `_notes/notes/rockhounding/rocks/sedimentary/...`
- **Minerals:** `_notes/notes/rockhounding/rocks/minerals/...`

### Category Landing Pages

Category landing pages are in:
```
_pages/rockhounding/rocks/{igneous|metamorphic|sedimentary}/index.md
```

### Graph Coloring

The interactive graph colors rock nodes by class (igneous/sedimentary/metamorphic) based on these paths. Keep new rock notes in the correct folder to get proper coloring.

## Redirects for Legacy Paths

Old URLs now redirect to new locations:
- Old: `/rockhounding/rocks/category/{igneous|metamorphic|sedimentary}/`
- Old: `/rockhounding/rocks/granite/` (top-level)

Redirect rules are defined in `netlify.toml`. Update internal links to point to new paths to avoid redirect hops.

## Tumbling Log

The tumbling log checklist is at:
- File: [`_pages/tumbling/log-checklist.md`](../_pages/tumbling/log-checklist.md)
- URL: `/tumbling/log-checklist/`

Use this checklist when adding or updating tumbling batch logs.

## Site Features

Spectrum Syntax includes:

- **Roam-style double bracket links:** Link notes with `[[Note Title]]`
- **Automatic backlinks:** See what notes link to the current page
- **Hover link previews:** Preview note content on hover
- **Interactive notes graph:** Visual representation of note connections
- **Simple, responsive design:** Works on desktop and mobile
- **Markdown or HTML notes:** Use whichever format you prefer

## Best Practices

1. **Use consistent paths:** Keep rock notes in the correct category folders
2. **Update internal links:** Point to new paths instead of relying on redirects
3. **Add meaningful titles:** Use descriptive titles for better linking
4. **Use double brackets:** Link related notes with `[[Note Title]]`
5. **Add front matter:** Include proper metadata in note front matter
6. **Check assets:** Verify images exist before referencing them

## Next Steps

- See [Development Guide](development.md) for testing your changes
- See [Scripts Documentation](scripts.md) for available automation tools
