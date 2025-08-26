<%*
/* ===== Rock Tumbling – NatGeo Pro (2-lb) =====
   1) Prompts for weights & prefs
   2) Computes per-stage amounts
   3) Prints YAML frontmatter at the very top (so Obsidian registers Properties)
*/

// helpers
const r1 = n => (Math.round(n*10)/10).toFixed(1);
const r0 = n => String(Math.round(n));

// prompts
const batchNo = await tp.system.prompt("Batch number (e.g., 01)", "01");
const rock_g = Number(await tp.system.prompt("Actual rock weight (g)", "450"));
const g_per_tbsp = Number(await tp.system.prompt("Approx grams per Tbsp (optional; Enter to skip)", ""));
const tbsp_lb_coarse = Number(await tp.system.prompt("Tbsp per lb — Coarse (default 2)", "2"));
const tbsp_lb_med    = Number(await tp.system.prompt("Tbsp per lb — Medium (default 2)", "2"));
const tbsp_lb_pre    = Number(await tp.system.prompt("Tbsp per lb — Pre-polish (default 2)", "2"));
const tbsp_lb_polish = Number(await tp.system.prompt("Tbsp per lb — Polish (default 2)", "2"));

// calcs
const LB_PER_G = 1/453.59237;
const rock_lb = rock_g * LB_PER_G;

const s1_tbsp = rock_lb * tbsp_lb_coarse;
const s2_tbsp = rock_lb * tbsp_lb_med;
const s3_tbsp = rock_lb * tbsp_lb_pre;
const s4_tbsp = rock_lb * tbsp_lb_polish;

const hasG = !Number.isNaN(g_per_tbsp) && g_per_tbsp > 0;
const s1_g = hasG ? s1_tbsp * g_per_tbsp : null;
const s2_g = hasG ? s2_tbsp * g_per_tbsp : null;
const s3_g = hasG ? s3_tbsp * g_per_tbsp : null;
const s4_g = hasG ? s4_tbsp * g_per_tbsp : null;

// --- print YAML frontmatter at top ---
tR += `--- 
type: rock_tumbling_batch
batch_id: RT-${tp.date.now("YYYYMMDD")}-${batchNo}
date_started: ${tp.date.now("YYYY-MM-DD")}
project: Rock Tumbling
status: active
tumbler:
  brand: National Geographic
  model: Professional (2 lb barrel, 3-speed, hours/days timer)
  barrel_capacity_lb: 2
  expected_rock_weight_lb: 1
  speeds: [1, 2, 3]
  timer_hours_days: true
media:
  type: ceramic
  percent_of_load: 20-35
water: tap
calculator:
  actual_rock_weight_g: ${r0(rock_g)}
  actual_rock_weight_lb: ${r1(rock_lb)}
  tbsp_per_lb:
    coarse: ${r1(tbsp_lb_coarse)}
    medium: ${r1(tbsp_lb_med)}
    prepolish: ${r1(tbsp_lb_pre)}
    polish: ${r1(tbsp_lb_polish)}
  grams_per_tbsp: ${hasG ? r1(g_per_tbsp) : "n/a"}
tags: [rock/tumbling, batch, natgeo-pro]
---
`;
%>

# <% tp.file.title %>

> [!summary] Batch Summary
> **Goal:**  
> **Material mix:**  
> **Target finish:** (matte | satin | high-gloss)  
> **Notes:**  

## Equipment Used
- Tumbler:: Nat Geo Professional (2-lb rubber barrel)
- Barrel(s):: 1 × 2 lb
- RPM / speed setting:: (1/2/3)
- Timer setting:: (hrs/days)
- Media on hand:: (ceramic smalls recommended)
- Grits/polishes on hand:: (SiC 60/90, SiC 120/220, 500, AO polish)

## Rock Inventory (Rough)
| ID | Origin (where/when) | Identification | Mohs | Size (mm) | Starting Weight (g) | Notes |
|---|---|---|---|---|---:|---|
| R-01 |  |  |  |  |  |  |
| R-02 |  |  |  |  |  |  |

**Total starting weight (g)::**  
**Fragility risks (pits, cracks, soft inclusions)::**

> [!tip] Load & Fill
> Aim **2/3–3/4 full**. Stage 1: mostly rocks. Stages 2–4: add **20–35% smalls/media**.

---

## Stage 1 — Coarse Grind
**Grit:** 60/90 SiC  
**Start:** <% tp.date.now("YYYY-MM-DD") %> **End:**  \_ \_ \_  **Duration (days)::**  
- Barrel fill %::  
- Water level:: (just below top layer / measured mL)  
- Media used:: (Y/N; type/size)  
- **Grit amount (Tbsp)::** <% r1(s1_tbsp) %><% hasG ? ` (~${r0(s1_g)} g)` : "" %>  
- Maintenance:: (burped? top-ups? leaks?)  
- Observations:: (chipping, froth, noise, smell)

**Decision:** Repeat Stage 1? (Y/N) — Why::

---

## Stage 2 — Medium Grind
**Grit:** 120/220 SiC  
**Start:**  **End:**  **Duration (days)::**  
- Barrel fill %:: (~30% media)  
- Water level::  
- Media used::  
- **Grit amount (Tbsp)::** <% r1(s2_tbsp) %><% hasG ? ` (~${r0(s2_g)} g)` : "" %>  
- Maintenance::  
- Observations::  

---

## Stage 3 — Pre-Polish
**Grit:** 500 (SiC or AO)  
**Start:**  **End:**  **Duration (days)::**  
- Barrel fill %::  
- Water level::  
- Media used::  
- **Grit amount (Tbsp)::** <% r1(s3_tbsp) %><% hasG ? ` (~${r0(s3_g)} g)` : "" %>  
- Observations:: (scratches gone? even surface?)

---

## Stage 4 — Polish
**Polish:** Aluminum Oxide (TXP or similar)  
**Start:**  **End:**  **Duration (days)::**  
- Barrel fill %::  
- Water level::  
- Media used:: (dedicated polish-only media recommended)  
- **Polish amount (Tbsp)::** <% r1(s4_tbsp) %><% hasG ? ` (~${r0(s4_g)} g)` : "" %>  
- Observations:: (shine level, haze, orange peel)

---

## Optional Finishing
**Burnish:** Soap/Borax, ~30–120 min (~1 tsp per lb of load).  
**GemFoam (optional):** duration & effect::  

---

## Cleaning & Cross-Contamination Checklist
- [ ] Rinse rocks thoroughly between stages (don’t let slurry dry on).  
- [ ] Scrub rocks & barrel (seams, crevices, lid).  
- [ ] Use **stage-dedicated media** for polish or clean it meticulously.  
- [ ] **Do not** pour slurry down drains; collect & dispose responsibly.  
- [ ] Inspect for pits/cracks before advancing.  
Notes::  

---

## Measurements & Yields
- Ending weight after Stage 1 (g)::  
- Ending weight after Stage 2 (g)::  
- Ending weight after Stage 3 (g)::  
- Final weight (g)::  
- Yield (% of start)::  
- Best pieces (IDs)::  

## Results
- Finish quality:: (poor / fair / good / great / mirror)  
- Photos:: ![[attach-before.jpg]] → ![[attach-after.jpg]]  
- Pieces set aside for rework:: (IDs & reason)  
- Gift/keep/sell plan::  

## Troubleshooting (if needed)
- Haze/cloudiness::  
- Scratches/pits::  
- Flat spots/bruising::  
- Grit carryover suspected?:: (what stage?)  
Actions taken:: (repeat pre-polish, longer polish, burnish, etc.)

---

## Time & Consumables Log
| Date | Stage | Speed | Timer (h/d) | Grit/Polish | Amount (Tbsp) | Media | Notes |
|---|---|---|---|---|---:|---|---|
|  |  |  |  |  |  |  |  |

**Total grit used (g)::**  **Total polish used (g)::**  **Run-hours::**

## Lessons Learned (for next batch)
-  
-  
