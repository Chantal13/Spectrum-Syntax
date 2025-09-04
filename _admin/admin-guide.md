---
layout: note
title: Admin Page Guide
permalink: /admin/guide/
tags:
  - admin
  - docs
---

# Admin Page Guide

This guide explains how to use the Tumbling Admin at `/admin/` to create and edit tumbling logs without hand‑editing front matter or asset paths.

## Authentication (Username/Password)

Important: The simple login on `/admin/` is client‑side only and is not secure for protecting sensitive content on a public site. Anyone can view the page source and read whatever credentials are embedded in JavaScript. For production protection, use Netlify’s password protection or Basic Auth headers (recommended below). The JavaScript login is fine for local use or light guardrails on non‑sensitive content.

### Quick (dev/testing) — inline JS login (now removed)
Previously, `/admin/` used a client‑side login form with hard‑coded credentials. This has been removed in favour of server‑side Basic Auth. If you need a temporary local-only gate for testing, use a dev branch or serve locally.

### Production (recommended) — protect /admin at the edge
Use Netlify to require auth before the page is served. Two common options:

Option A (enabled): Netlify Basic Auth for just the admin paths
1) Open `netlify.toml` and add headers for `/admin` and `/admin/*`:
   
   ```toml
   [[headers]]
     for = "/admin"
     [headers.values]
       Basic-Auth = "youruser:yourpassword"

   [[headers]]
     for = "/admin/*"
     [headers.values]
       Basic-Auth = "youruser:yourpassword"
   ```

   - You can list multiple user:pass pairs separated by spaces, e.g.: `"alice:pass bob:pass2"`.
   - Commit and deploy. Browsers will prompt for credentials before serving any `/admin` page.
   - Keep in mind these credentials live in your repository. If the repo is public, rotate them as needed and treat them as non‑sensitive.

Option B: Site‑wide password (fastest)
- In Netlify UI: Site settings → Access control → Password → set a site password.
- This protects the entire site (not just `/admin`), which may not be desirable long‑term but is quick and secure.

Advanced
- For private repos, you can still use Basic Auth in `netlify.toml` safely.
- If you want to avoid committing credentials, generate a `_headers` file at build time from environment variables and add `Basic-Auth` entries there.
- For full user management, consider Netlify Identity + a CMS (outside the scope of this simple admin).

## Overview
- Tabs: Checklist, New Log Builder, Edit Existing.
- Inline image uploads: Save milestone images directly into `assets/tumbling/` using the File System Access API.
- Standardized naming: Files save as `rough-<batch>.jpg`, `after-s1-<batch>.jpg`, … `after-burnish-<batch>.jpg` inside a batch‑specific subfolder.
- Auto paths: Image fields are auto‑filled to the correct `/assets/tumbling/<subfolder>/<name>.jpg` values.

## New Log Builder
- Basics: Fill Batch, Title, Status, Dates, and optional metadata.
- Asset Subfolder: Defaults to the Batch (e.g., `001`). You can override (e.g., `002/August 29, 2025`).
- Prefill milestone image paths: Generates image URLs using the subfolder and batch naming convention.
- Upload milestone images:
  1) Click “Choose assets/tumbling…”, select your repo folder (or `assets/tumbling`).
  2) Select files for Rough, After S1–S4, Burnish.
  3) Click “Save with standard names”. Files are written to the subfolder and fields update automatically.
- Generate Markdown: Click “Generate Markdown” to preview the front matter + (optional) body template; Download or Copy as needed.
- Drafts: Use Save Draft / Load Draft to temporarily store the form inputs in your browser.

## Edit Existing
- Choose `_notes/tumbling` folder and pick a file, then “Load Selected”.
- The form and body editor populate from the file’s front matter and content.
- Asset Subfolder: Inferred from existing image paths when possible; otherwise falls back to the Batch.
- Upload milestone images: Same flow as Builder; saving images updates the image fields in the form. Then click “Save” to write back to the file.

## Naming + Paths
- Folder: Defaults to `<batch>`, but can be nested, e.g., `002/August 29, 2025`.
- Filenames: `rough-<batch>.jpg`, `after-s1-<batch>.jpg`, `after-s2-<batch>.jpg`, `after-s3-<batch>.jpg`, `after-s4-<batch>.jpg`, `after-burnish-<batch>.jpg`.
- Paths: `/assets/tumbling/<subfolder>/<filename>`.

## Browser Requirements
- The local image uploader uses the File System Access API (Chrome, Edge, Brave). Safari/Firefox may not allow direct writing into your repo folder.

## Troubleshooting
- If you can’t select folders or save files, ensure you’re in a Chromium‑based browser and that you’ve selected the correct repo (or `assets/tumbling`) directory.
- If fields don’t auto‑fill, make sure `Batch` is entered. Re‑click “Prefill milestone image paths”.
- After uploading, remember to “Save” the edited markdown file in the Editor tab (or Download/Copy from Builder) so the new image paths are stored in the file.

## Related
- Tumbling Log Checklist: `/admin/tumbling/log-checklist/`
---
