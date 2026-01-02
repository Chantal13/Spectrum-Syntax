---
title: Jasper Varieties
tags:
  - rockhound
  - rockhound/minerals
layout: note
parent: "[[jasper]]"
---
{% include rock-card.html rock=page %}

Collection of jasper varieties showcasing different colors and patterns.

<div class="rock-card-grid">
  {%- assign varieties = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/rocks/minerals/jasper-varieties/'" -%}
  {%- assign varieties = varieties | sort: 'title' -%}
  {%- for n in varieties -%}
    {%- assign filename = n.path | split: '/' | last -%}
    {%- unless filename == 'jasper-varieties.md' -%}
      {% include rock-card.html rock=n %}
    {%- endunless -%}
  {%- endfor -%}
</div>
