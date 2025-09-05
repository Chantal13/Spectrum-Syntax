---
title: Epidote
draft: false
tags:
- rockhounding
- minerals
aliases:
- epidotes
- Epidotes
- Epidote
thumbnail: https://upload.wikimedia.org/wikipedia/commons/b/b8/%D0%AD%D0%BF%D0%B8%D0%B4%D0%BE%D1%82%28%D0%BF%D1%83%D1%88%D0%BA%D0%B8%D0%BD%D0%B8%D1%82%29.jpg
hardness: 6.5
luster: null
streak: null
---
{% include rock-card.html rock=page %}

{%- comment -%} Show varieties for this mineral {%- endcomment -%}
{%- assign root = '_notes/rockhounding/rocks/minerals/' -%}
{%- assign all = site.notes | where_exp: "n", "n.path contains root" -%}
{%- assign b_slug = page.path | split: '/' | last | replace: '.md','' -%}
{%- assign base_dir = root | append: b_slug | append: '/' -%}

<div class="rock-card-grid">
  {%- assign immediate_candidates = all | where_exp: "n", "n.path contains base_dir" -%}
  {%- assign immediate_candidates = immediate_candidates | sort: 'title' -%}
  {%- for n in immediate_candidates -%}
    {%- assign parts = n.path | split: '/' -%}
    {%- assign count = parts | size -%}
    {%- if count == 6 -%}
      {% include rock-card.html rock=n %}
    {%- endif -%}
  {%- endfor -%}
</div>

{%- assign deeper_candidates = all | where_exp: "n", "n.path contains base_dir" -%}
{%- assign deeper_count = 0 -%}
{%- for n in deeper_candidates -%}
  {%- assign parts = n.path | split: '/' -%}
  {%- assign count = parts | size -%}
  {%- assign last = parts | last -%}
  {%- if count >= 7 and last != 'index.md' -%}
    {%- assign deeper_count = deeper_count | plus: 1 -%}
  {%- endif -%}
{%- endfor -%}
{%- if deeper_count > 0 -%}
  <h3>Varieties</h3>
  <div class="rock-card-grid">
    {%- assign deeper_candidates = deeper_candidates | sort: 'title' -%}
    {%- for n in deeper_candidates -%}
      {%- assign parts = n.path | split: '/' -%}
      {%- assign count = parts | size -%}
      {%- assign last = parts | last -%}
      {%- if count >= 7 and last != 'index.md' -%}
        {% include rock-card.html rock=n %}
      {%- endif -%}
    {%- endfor -%}
  </div>
{%- endif -%}

Epidote is a pistachio‑green silicate mineral formed during low‑ to medium‑grade metamorphism and hydrothermal alteration; it commonly occurs with quartz and colors unakite.

---

## Appearance & Identification
- **Color:** Pistachio-green to dark green  
- **Luster:** Vitreous (glassy)  
- **Transparency:** Transparent to translucent  
- **Crystal Habit:** Prismatic or granular, but often massive  
- **Hardness:** [[Mohs Hardness Scale|Mohs]] 6–7  
- **Cleavage:** One good cleavage plane  

> [!tip] Field ID  
> Epidote is usually seen as green patches or grains in **[[unakite]] pebbles**. Look for the pink + green mottled pattern.  

---

## [[Rock Tumbling|Tumbling]] Qualities
- **Hardness:** [[Mohs Hardness Scale|Mohs]] 6–7 (similar to [[quartz]] and [[feldspar]])  
- **Polishing Notes:**  
  - Epidote alone is not often tumbled, but in [[unakite]] it polishes well.  
  - Produces a smooth, satin-like finish with rich green tones.  
- **Lapidary Use:** Sometimes cut into cabochons or beads, often as part of [[unakite]].  

> [!warning] Pure epidote can be brittle and may fracture in a tumbler. Works best when polished as part of [[unakite]].  

---

## Connection to Lake Ontario
- **Origin:** Forms during metamorphism of [[feldspar]]-rich rocks (like [[granite]]).  
- **Transport:** Epidote-rich rocks (like [[unakite]] and [[gneiss]]) were carried south from the Canadian Shield by glaciers.  
- **Where to Find:**  
  - Primarily in **[[unakite]] pebbles** on GTA & Durham beaches (Scarborough, Rouge River, Lynde Shores, Darlington).  
  - Rarely as standalone mineral fragments.  

---

## Mineral Family
Epidote is part of the **silicate mineral group** and commonly occurs in metamorphic environments.  


---

## Related Stones
- **[[unakite]]** → Epidote + [[feldspar]] + [[quartz]]  
- **[[gneiss]]** → May contain small epidote inclusions  
- **Feldspar** → Often altered to epidote during metamorphism  

---

## References
- [Epidote (Wikipedia)](https://en.wikipedia.org/wiki/Epidote)  
- [Ontario Geological Survey – Geology of Ontario](https://www.ontario.ca/page/geology-ontario)  
- [Metamorphic Rocks (Wikipedia)](https://en.wikipedia.org/wiki/Metamorphic_rock)  
