---
title: Quartz Varieties
tags:
  - rockhound
  - rockhound/minerals
layout: note
parent: "[[Quartz]]"
---
{% include rock-card.html rock=page %}

Collection of quartz varieties including crystalline forms (amethyst, rose quartz) and microcrystalline forms (chert, chalcedony).

<div class="rock-card-grid">
  {%- assign varieties = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/rocks/minerals/quartz-varieties/'" -%}
  {%- assign varieties = varieties | sort: 'title' -%}
  {%- for n in varieties -%}
    {%- assign filename = n.path | split: '/' | last -%}
    {%- unless filename == 'quartz-varieties.md' -%}
      {% include rock-card.html rock=n %}
    {%- endunless -%}
  {%- endfor -%}
</div>
