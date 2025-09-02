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
