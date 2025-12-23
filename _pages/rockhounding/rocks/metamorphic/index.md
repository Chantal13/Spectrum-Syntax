---
layout: page
title: Metamorphic Rocks
summary: Metamorphic rock notes with ID cards and quick details.
permalink: /rockhounding/rocks/metamorphic/
aliases:
  - metamorphic
---
<h1>Metamorphic Rocks</h1>

<div class="rock-card-grid">
  {%- assign notes = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/rocks/metamorphic/'" -%}
  {%- assign notes = notes | sort: 'title' -%}
  {%- for n in notes -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>
