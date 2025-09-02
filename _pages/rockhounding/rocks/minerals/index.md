---
layout: page
title: Minerals
permalink: /rockhounding/rocks/minerals/
---

<h1>Minerals</h1>

<div class="rock-card-grid">
  {%- assign items = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/minerals/'" -%}
  {%- assign items = items | sort: 'title' -%}
  {%- for n in items -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>
