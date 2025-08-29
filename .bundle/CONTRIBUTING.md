# Contributing to Spectrum Syntax

Thanks for helping! This site is a Jekyll project deployed on Netlify. I write in Obsidian, so Markdown (with a bit of Liquid) is the main interface. This doc explains how to add content—especially tumbling batches—and how to work locally.

## TL;DR

bundle install → bundle exec jekyll serve

Add a batch MD file under `_notes/tumble_logs/` (use the template below)

Put images in `assets/tumbling/<batch-id>/`

Commit → git pull --rebase → git push

## Project shape
```
/_config.yml
/_layouts/
  default.html
  tumble.html            # single-batch page
/_notes/
  tumbling/index.md      # batches index (/tumbling/)
  tumble_logs/           # individual batch files live here
/_plugins/
  bidirectional_links_generator.rb
/_sass/
  _style.scss            # global styles
  _tumbling.scss         # index + batch styles
/styles.scss             # entrypoint -> /styles.css
/assets/tumbling/        # images by batch (e.g., 001/, 002/)
Gemfile, Gemfile.lock
netlify.toml
```

## Collections

notes → general notes (layout: note via defaults)

tumble_logs → tumbling batches (layout: tumble)

The site also tolerates a legacy tumbles collection, but please use tumble_logs.

## Local setup

### Prereqs

Ruby 3.2.x, Bundler 2.7.x

(Optional) Netlify CLI if you want to proxy production environment

### Install & run

```
bundle install
bundle exec jekyll serve
# open http://127.0.0.1:4000
```

If Bundler complains about platform-specific gems, you can run:

```
bundle lock --normalize-platforms
```

## Adding a new tumbling batch

Create the file in `_tumble_logs/`
Suggested name: `YYYY-MM-DD-batch-<id>.md` (e.g., 2025-08-21-batch-001.md)

Paste this front matter (adjust as needed):

```yaml
---
layout: tumble
title: "Batch 001 – Baby’s First Tumble"
batch: "001"

# Status options: Pending | In Progress | Completed
status: In Progress

# Dates (YYYY-MM-DD)
date_started: 2025-08-21
date_finished:

# Gear & context
tumbler: "National Geographic Professional Rock Tumbler"
origin: "Blue Marble NG Kit"

# Rocks (chips are colour-coded; add anything—unknowns get a neutral chip)
rocks:
  - agate
  - jasper
  - sodalite
  - quartz

# Freeform notes
notes: >-
  Short notes about this batch. Use Canadian English in prose.

# Brand shown alongside grit/polish labels
consumables_brand: "National Geographic"

# Milestone photos (any can be omitted)
# Any image fields are optional; missing ones simply won't render.
images:
  rough: "/assets/tumbling/001/rough.jpg"
  cover: "/assets/tumbling/001/cover.jpg"
  after_stage_1: "/assets/tumbling/001/after-s1.jpg"
  after_stage_2: "/assets/tumbling/001/after-s2.jpg"
  after_stage_3: "/assets/tumbling/001/after-s3.jpg"
  after_stage_4: "/assets/tumbling/001/after-s4.jpg"
  after_burnish: "/assets/tumbling/001/after-burnish.jpg"
  gallery:
    - "/assets/tumbling/001/detail1.jpg"
    - src: "/assets/tumbling/001/tray.jpg"
      alt: "Sorting tray"
      caption: "Size sorting before Stage 1"

# Stages (progress can be inferred from these)
stages:
  - stage: 1
    name: "Coarse Grind"
    start: 2025-08-21
    end:
    grit: "60/90 SiC"
    barrel_fill_pct: "75%"
    water_level: "Just below top layer"
    media_used: "None"
    amount_tbsp: 2
    maintenance: "N/A"
    observations: "Chipping reduced; froth normal"
    decision:
      repeat:
      why:
    images:
      # Example: photo of the load before the coarse grind (Stage 1)
      # - src: "/assets/tumbling/001/stage1-before.jpg"
      #   alt: "Before Stage 1 (rough)"
      #   caption: "Load before coarse grind"
      - "/assets/tumbling/001/stage1-start.jpg"
      - src: "/assets/tumbling/001/stage1-end.jpg"
        alt: "Stage 1 end"
        caption: "Edges rounding"

  - stage: 2
    name: "Medium Grind"
    start:
    end:
    grit: "120/220 SiC"
    barrel_fill_pct: "Use media ~30% of load"
    water_level: "Just below top layer"
    media_used: "Plastic pellets? Ceramic? Approx. 30% of load"
    amount_tbsp: 2
    maintenance: "Top-ups; noise/leaks; mid-week checks"
    observations: "Scratch removal progress; size balance; any chips?"
    decision:
      repeat:
      why:
    images: []

  - stage: 3
    name: "Pre-Polish"
    start:
    end:
    grit: "500 SiC"
    barrel_fill_pct: "Maintain 2/3–3/4 full with media"
    water_level: "Just below top layer"
    media_used: "Add pellets/ceramic to maintain spacing"
    amount_tbsp: 2
    maintenance: "Rinse checks; lid seal; slurry thickness"
    observations: "No visible scratches; uniform matte; ready for polish?"
    decision:
      repeat:
      why:
    images: []

  - stage: 4
    name: "Polish"
    start:
    end:
    polish: "Aluminum Oxide (TXP)"
    barrel_fill_pct: "2/3–3/4 full; polish-only media"
    water_level: "Just below top layer; clean water"
    media_used: "Dedicated polish-only media"
    amount_tbsp: 2
    maintenance: "Clean barrel; isolate polish-only media"
    observations: "Gloss level; haze/orange peel; under-polished spots"
    decision:
      repeat:
      why:
    images: []

  - stage: 5
    name: "Burnish"
    start:
    end:
    grit: "Soap/Borax burnish"
    barrel_fill_pct: "Same load; maintain spacing with pellets"
    water_level: "Full (soap/borax water)"
    media_used: "Plastic pellets recommended"
    amount_tbsp:
    maintenance: "Foam control; rinse cycles; contamination check"
    observations: "Final shine; any haze or foam; orange peel?"
    decision:
      repeat:
      why:
    images:
      - "/assets/tumbling/001/after-burnish.jpg"
---
```

Add images under `assets/tumbling/<batch-id>/`
Examples:

```
assets/tumbling/001/rough.jpg
assets/tumbling/001/after-s1.jpg
assets/tumbling/001/after-s4.jpg
assets/tumbling/001/after-burnish.jpg
```

If any are missing, they are simply omitted from the UI (no placeholder displayed).

Preview locally. Your batch will appear on `/tumbling/`.

## Writing notes (Obsidian)

Wiki-style links like [[Some Note]] are converted to internal links by a custom plugin during build.

If you need to show Liquid in a note (not execute it), wrap with:

```liquid
{% raw %}
{{ site.whatever }}
{% endraw %}
```

## Status & rocks

Status pills: Pending, In Progress, Completed

Rocks: common tumbler types (agate, jasper, quartz, sodalite, dalmatian jasper, aventurine, obsidian, onyx, petrified wood, amethyst, fluorite, carnelian, tiger’s eye, labradorite, unakite, etc.). Unknowns get a neutral chip automatically.

## Styles

Edit SCSS in _sass/ (_style.scss, _tumbling.scss) and import via styles.scss.

Jekyll compiles to `/styles.css`. Colours, spacing, and chips/pills are themeable via SCSS variables.

## Custom plugin notes

`_plugins/bidirectional_links_generator.rb`:

Converts [[links]] → `<a class="internal-link">`.

Generates `_includes/notes_graph.json`.

Safe if a note has no title; it falls back to batch → slug → filename.

## Git workflow

Use rebase by default (keeps history tidy):

```
# stage & commit
git add -A
git commit -m "Add batch 001 with images"

# update your branch before pushing
git pull --rebase origin main

# then push
git push origin main
```

If you hit conflicts during rebase:

```
# fix files, then
git add <fixed-files>
git rebase --continue
```
