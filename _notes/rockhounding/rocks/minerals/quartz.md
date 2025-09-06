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
hardness: 7
luster: null
streak: White
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
    {%- assign last = parts | last -%}
    {%- if count == 6 -%}
      {% include rock-card.html rock=n %}
    {%- endif -%}
    {%- if count == 7 and last == 'index.md' -%}
      {% include rock-card.html rock=n %}
    {%- endif -%}
  {%- endfor -%}
  {%- assign chalcedony_dir = base_dir | append: 'chalcedony/' -%}
  {%- assign agate_dir = chalcedony_dir | append: 'agate/' -%}
  {%- assign agate_main_path = agate_dir | append: 'agate.md' -%}
  {%- assign agate_main = all | where_exp: "n", "n.path == agate_main_path" -%}
  {%- for n in agate_main -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>

{%- assign deeper_candidates = all | where_exp: "n", "n.path contains base_dir" -%}
{%- assign deeper_count = 0 -%}
{%- for n in deeper_candidates -%}
  {%- assign parts = n.path | split: '/' -%}
  {%- assign count = parts | size -%}
  {%- assign last = parts | last -%}
  {%- if count >= 7 and last != 'index.md' and n.path != agate_main_path -%}
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
      {%- if count >= 7 and last != 'index.md' and n.path != agate_main_path -%}
        {% include rock-card.html rock=n %}
      {%- endif -%}
    {%- endfor -%}
  </div>
{%- endif -%}

Quartz (SiO₂) is a hard, abundant mineral found in igneous, metamorphic, and sedimentary rocks; it forms hexagonal crystals and occurs in many well‑known varieties.

Related: [[Chalcedony]], [[Jasper]], [[Agate]]
