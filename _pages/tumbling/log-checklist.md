---
layout: note
title: Tumbling Log Checklist
permalink: /tumbling/log-checklist/
breadcrumbs:
  - title: Rockhounding
    url: /rockhounding/
---

# Tumbling Log Checklist

Use this checklist when creating or updating a tumbling batch log so everything renders nicely in the index and detail views.
This page replaces the old `/admin` path.

## Required Images
- [ ] Rough load photo (`images.rough`)
- [ ] Final result photo — pick one of:
  - [ ] After Stage 4 (`images.after_stage_4`)
  - [ ] After Burnish (`images.after_burnish`)
  - [ ] Optional progress photos (helpful, not required):
    - [ ] After Stage 1 (`images.after_stage_1`)
    - [ ] After Stage 2 (`images.after_stage_2`)
    - [ ] After Stage 3 (`images.after_stage_3`)
    - [ ] After Stage 5 (if applicable) (`images.after_stage_5`)
- Notes
  - The page will automatically choose a cover image in this order: `cover` → `after_stage_4` → `after_burnish` → `rough`.
  - The index uses the best available image in this order: `cover` → `after_stage_5` → `after_stage_4` → `after_stage_3` → `after_stage_2` → `after_stage_1` → `after_burnish` → `rough`.

## Page Front Matter
- [ ] `title` — descriptive name, e.g., “Baby’s First Tumble”
- [ ] `batch` — short batch id, e.g., `001`
- [ ] `status` — `Pending` | `In Progress` | `Completed`
- [ ] `date_started` — `YYYY-MM-DD`
- [ ] `date_finished` — `YYYY-MM-DD` (optional until done)
- [ ] `tumbler` — model or rig name
- [ ] `origin` — where the rocks came from
- [ ] `rocks` — list of rock types (used for chips)
- [ ] `notes` — short freeform summary
- [ ] `consumables_brand` — shown next to grit/polish in tables
- [ ] `images` — milestone photos as above

## Stages Array (Per Stage)
Provide the following for each stage you run. Stages are typically 1–5.

- [ ] `stage` — number `1`..`5`
- [ ] `name` — e.g., “Coarse Grind”, “Medium”, “Pre-Polish”, “Polish”, “Burnish”
- [ ] Timing
  - [ ] `start` — `YYYY-MM-DD`
  - [ ] `end` — `YYYY-MM-DD`
- [ ] Abrasive
  - For grind stages (1–3): `grit` — e.g., `60/90 SiC`, `120/220 SiC`, `500 SiC`
  - For polish stage (4): `polish` — e.g., `Aluminum Oxide (TXP)`
- [ ] Barrel details
  - [ ] `barrel_fill_pct` — e.g., `75%`
  - [ ] `water_level` — e.g., `Just below top layer`
  - [ ] `media_used` — e.g., `Ceramic media`, `Plastic pellets`, `None`
  - [ ] `amount_tbsp` — tablespoons of abrasive/polish
- [ ] Maintenance (optional)
  - [ ] `maintenance` — top-ups, checks, leak/foam notes
- [ ] Observations
  - [ ] `observations` — what you saw, issues, rock behaviour
- [ ] Decision block (optional but helpful)
  - [ ] `decision.repeat` — `yes` | `no`
  - [ ] `decision.why` — short reason
- [ ] Images for this stage (optional)
  - [ ] `images` — array of image paths; first one is treated as primary

## Example Stage Snippet
```yaml
- stage: 2
  name: "Medium Grind"
  start: 2025-09-01
  end: 2025-09-07
  grit: "120/220 SiC"
  barrel_fill_pct: "70% with media"
  water_level: "Just below top layer"
  media_used: "Ceramic triangles"
  amount_tbsp: 2
  maintenance: "Mid-week top-up"
  observations: "Edges rounding well; a few pits remain."
  decision:
    repeat: no
    why: "Advancing most stones; a few will be held back next batch"
  images:
    - "/assets/tumbling/XYZ/after-s2.jpg"
```

## Tips
- Keep at least one clear “final” photo (Stage 4 or Burnish) — it’s used prominently.
- If a stage is skipped, omit it or leave fields blank; the layout will fall back to the nearest reasonable image.
- Set both `batch` and `title` — the index shows “Batch — Title”.
