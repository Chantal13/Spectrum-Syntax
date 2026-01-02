---
layout: page
title: Sedimentary Rocks
summary: Sedimentary rock notes with ID cards and quick details.
permalink: /rockhounding/rocks/sedimentary/
aliases:
  - sedimentary
---
<h1>Sedimentary Rocks</h1>


<div class="rock-card-grid">
  {%- assign notes = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/rocks/sedimentary/'" -%}
  {%- assign notes = notes | sort: 'title' -%}
  {%- for n in notes -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>
