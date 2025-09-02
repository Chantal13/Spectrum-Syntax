---
layout: page
title: Igneous Rocks
permalink: /rockhounding/rocks/igneous/
aliases:
  - igneous
---

<h1>Igneous Rocks</h1>

<div class="rock-card-grid">
  {%- assign notes = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/igneous/'" -%}
  {%- assign notes = notes | sort: 'title' -%}
  {%- for n in notes -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>
