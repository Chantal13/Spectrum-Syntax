---
title: Jasper
draft: false
tags:
  - rockhounding
  - tumbling
aliases:
  - jaspers
  - Jaspers
  - Jasper
thumbnail: "/assets/Rockhound - 4 of 4.jpeg"
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

Jasper is an opaque chalcedony ([[quartz|quartz]]) coloured by mineral impurities, usually iron oxides. It often originates in silica-rich [[sedimentary]] deposits, though glacial action has moved it widely.  

**Appearance & Identification:**  
- Opaque, solid colors  
- Reds, browns, yellows, greens  
- Patterns: speckled, striped, or brecciated  
- Lacks translucency (distinguishes it from [[agate]])  

> [!tip] Tumbling Qualities  
> - Hardness: [[Mohs Hardness Scale|Mohs]] 6.5–7  
> - Produces a glossy, smooth polish  
> - Colors deepen after [[Rock Tumbling|tumbling]]  

**Rock Category:** **[[sedimentary]]**, though considered part of the [[quartz]] family.  

> [!info] Did you know?  
> Jasper is a silica-rich stone that comes from **[[sedimentary]] environments**.  
