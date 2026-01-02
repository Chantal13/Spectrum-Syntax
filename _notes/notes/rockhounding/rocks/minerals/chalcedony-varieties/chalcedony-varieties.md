---
title: Chalcedony Varieties
tags:
  - rockhound
  - rockhound/minerals
layout: note
parent: "[[chalcedony]]"
---
{% include rock-card.html rock=page %}

Collection of chalcedony varieties including agates and other microcrystalline quartz forms.

<div class="rock-card-grid">
  {%- assign varieties = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/rocks/minerals/chalcedony-varieties/'" -%}
  {%- assign varieties = varieties | sort: 'title' -%}
  {%- for n in varieties -%}
    {%- assign filename = n.path | split: '/' | last -%}
    {%- unless filename == 'chalcedony-varieties.md' -%}
      {% include rock-card.html rock=n %}
    {%- endunless -%}
  {%- endfor -%}
</div>
