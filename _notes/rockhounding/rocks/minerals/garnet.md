---
title: Garnet
draft: false
tags:
  - rockhounding
  - tumbling
aliases:
  - garnet
  - garnets
  - Garnets
thumbnail: "/assets/Rockhound - 1 of 4.jpeg"
hardness: 7
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

Garnet is a group of silicate minerals that are well known for their **deep red crystals**, though they can also occur in green, orange, brown, yellow, and even black varieties. Garnets form under conditions of high temperature and pressure, making them common in **metamorphic rocks** such as [[gneiss]] and schist.  

On the north shores of Lake Ontario, garnets are most often found embedded in **[[gneiss]] pebbles** carried south from the Canadian Shield by glaciers. Occasionally, small loose garnet crystals may also be found in beach gravels.

---

## Appearance & Identification
- **Crystal Shape:** Typically dodecahedral (12-sided) or trapezohedral (24-sided) 
- **Colour:** Most common in deep red, but can also be orange, brown, green, or black  
- **Luster:** Glassy to resinous  
- **Transparency:** Transparent to opaque  
- **Hardness:** [[Mohs Hardness Scale|Mohs]] 6.5–7.5  

> [!tip] Field ID Tip  
> Look for small, dark red “spots” in banded [[gneiss]] pebbles — these are usually garnets. Hold them in the light to see their glassy shine.  

---

## Tumbling & Lapidary Qualities
- **Hardness:** [[Mohs Hardness Scale|Mohs]] 6.5–7.5 (comparable to [[quartz]])  
- **[[Rock Tumbling|Tumbling]] Notes:**  
  - Garnets embedded in [[gneiss]] polish best when the whole stone is tumbled.  
  - Loose garnet crystals may fracture; cabbing or faceting works better than [[Rock Tumbling|tumbling]] for individual crystals.  
- **Lapidary Use:** Popular in jewelry — often cut into cabochons or faceted as gemstones.  

> [!warning] Loose garnet crystals are brittle and may chip in a tumbler. For best results, collect garnet-bearing [[gneiss]] or schist pebbles.  

---

## Connection to Lake Ontario
- **Origin:** Garnets formed in ancient metamorphic rocks of the Canadian Shield.  
- **Transport:** Glaciers carried garnet-bearing rocks south into Southern Ontario.  
- **Where to Find:**  
  - Embedded in [[gneiss]] pebbles along **Scarborough Bluffs** beaches.  
  - Carried down rivers like the **Rouge River** and **Don Valley** into the lake.  
  - Along gravelly stretches near **Darlington Provincial Park** and **Lynde Shores**.  

---

## Rock Family
Garnet is a **mineral**, not a rock, but is most commonly associated with **metamorphic rocks** like [[gneiss]] and schist.  

> [!info] Related content:  
> - [[gneiss|Gneiss]] → Learn about the metamorphic rock that often contains garnet.  
> - [[metamorphic|Metamorphic Rocks]] → See how garnet forms under heat and pressure.  

---

## Related Varieties
- **Almandine:** Deep red, most common type in Ontario [[gneiss]].  
- **Grossular:** Greenish variety, less common.  
- **Spessartine:** Orange to reddish-brown.  

---

## References
- [Garnet (Wikipedia)](https://en.wikipedia.org/wiki/Garnet)  
- [Ontario Geological Survey – Canadian Shield](https://www.ontario.ca/page/geology-ontario)  
- [Metamorphic Rocks (Wikipedia)](https://en.wikipedia.org/wiki/Metamorphic_rock)  
