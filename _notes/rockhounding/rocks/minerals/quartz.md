---
title: Quartz
draft: false
tags:
  - rockhounding
  - tumbling
aliases:
  - quartzes
  - Quartzes
  - Quartz
thumbnail: "/assets/tumbling/001/after-s4.jpg"
hardness: 7-7
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
  {%- assign sub_indexes = all | where_exp: "n", "n.path contains base_dir and n.path | split: '/' | size == 7 and n.path | split:'/' | last == 'index.md'" | sort: 'title' -%}
  {%- for n in sub_indexes -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
  {%- assign chalcedony_dir = base_dir | append: 'chalcedony/' -%}
  {%- assign agate_dir = chalcedony_dir | append: 'agate/' -%}
  {%- assign agate_main_path = agate_dir | append: 'agate.md' -%}
  {%- assign agate_main = all | where_exp: "n", "n.path == agate_main_path" -%}
  {%- for n in agate_main -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>

{%- assign deeper_pages = all | where_exp: "n", "n.path contains base_dir and n.path | split:'/' | size >= 7 and n.path | split:'/' | last != 'index.md' and n.path != agate_main_path" -%}
{%- if deeper_pages and deeper_pages.size > 0 -%}
  <h3>Varieties</h3>
  <div class="rock-card-grid">
    {%- assign deeper_pages = deeper_pages | sort: 'title' -%}
    {%- for n in deeper_pages -%}
      {% include rock-card.html rock=n %}
    {%- endfor -%}
  </div>
{%- endif -%}

Quartz (SiO₂) is one of the most common minerals. It forms in **[[igneous]]** ([[granite]]), **[[metamorphic]]** ([[gneiss]], schist), and **[[sedimentary]]** (cement, veins) contexts.  

**Appearance & Identification:**  
- Milky quartz: opaque white  
- Smoky quartz: translucent grey-brown  
- Chalcedony: waxy and semi-translucent  
- Hardness test: scratches glass  

> [!tip] Tumbling Qualities  
> - Hardness: [[Mohs Hardness Scale|Mohs]] 7  
> - Very durable  
> - Polishes to a reflective, glass-like finish  

**Rock Category:** Present in **all three rock types**.

> [!info] Fun fact:  
> Quartz appears in **all three rock families** — [[igneous]], [[sedimentary]], and [[metamorphic]] — which is why it’s so common.  
> Learn more here → [[igneous|Igneous Rocks]] | [[sedimentary|Sedimentary Rocks]] | [[metamorphic|Metamorphic Rocks]]
