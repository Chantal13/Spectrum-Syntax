---
layout: page
title: Metamorphic Rocks
permalink: /rockhounding/rocks/metamorphic/
aliases:
  - metamorphic
---

<h1>Metamorphic Rocks</h1>

<div class="rock-card-grid">
  {%- assign notes = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/metamorphic/'" -%}
  {%- assign notes = notes | sort: 'title' -%}
  {%- for n in notes -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>
