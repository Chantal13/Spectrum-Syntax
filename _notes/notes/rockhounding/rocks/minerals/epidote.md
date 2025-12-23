---
title: Epidote
draft: false
tags:
  - rockhound
  - rockhound/minerals
aliases:
  - epidotes
  - Epidotes
  - Epidote
thumbnail: https://upload.wikimedia.org/wikipedia/commons/b/b8/%D0%AD%D0%BF%D0%B8%D0%B4%D0%BE%D1%82%28%D0%BF%D1%83%D1%88%D0%BA%D0%B8%D0%BD%D0%B8%D1%82%29.jpg
hardness: 6–7
luster:
streak: Greyish white
---
<!-- Graph links: [[Unakite]] [[Gneiss]] [[Granite]] -->
{% include rock-card.html rock=page %}

{%- comment -%} Show varieties for this mineral {%- endcomment -%}
{%- assign root = '_notes/notes/rockhounding/rocks/minerals/' -%}
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

Epidote is a pistachio‑green silicate mineral formed during low‑ to medium‑grade metamorphism and hydrothermal alteration; it commonly occurs with [[quartz]] and colours [[unakite]].
