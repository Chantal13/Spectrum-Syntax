---
title: Feldspar
draft: false
tags:
  - rockhounding
  - minerals
thumbnail: "https://upload.wikimedia.org/wikipedia/commons/3/31/OrthoclaseBresil.jpg"
aliases:
  - Feldspar
hardness: 6
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

Feldspar is a group of rock‑forming silicate minerals (plagioclase and potassium feldspar) with good cleavage; they dominate many igneous rocks and are abundant in metamorphic and sedimentary settings.
- [Feldspar (Wikipedia)](https://en.wikipedia.org/wiki/Feldspar)  
- [Ontario Geological Survey – Geology of Ontario](https://www.ontario.ca/page/geology-ontario)  
- [Metamorphic Rocks (Wikipedia)](https://en.wikipedia.org/wiki/Metamorphic_rock)  
