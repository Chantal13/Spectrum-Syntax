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
thumbnail: "/assets/tumbling/001/after-s3.jpg"
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
  {%- assign immediate_children = all | where_exp: "n", "n.path contains base_dir and n.path | split: '/' | size == 6" | sort: 'title' -%}
  {%- for n in immediate_children -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>

{%- assign deeper_pages = all | where_exp: "n", "n.path contains base_dir and n.path | split:'/' | size >= 7 and n.path | split:'/' | last != 'index.md'" -%}
{%- if deeper_pages and deeper_pages.size > 0 -%}
  <h3>Varieties</h3>
  <div class="rock-card-grid">
    {%- assign deeper_pages = deeper_pages | sort: 'title' -%}
    {%- for n in deeper_pages -%}
      {% include rock-card.html rock=n %}
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
> Learn more here → [[sedimentary|Sedimentary Rocks]]
