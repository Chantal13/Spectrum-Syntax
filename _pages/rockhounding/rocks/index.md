---
layout: page
title: Rocks
permalink: /rockhounding/rocks/
---

<h1>Rocks</h1>

<h2>By Category</h2>
<ul>
  <li><a class="internal-link" href="{{ '/rockhounding/rocks/igneous/' | relative_url }}">Igneous</a></li>
  <li><a class="internal-link" href="{{ '/rockhounding/rocks/metamorphic/' | relative_url }}">Metamorphic</a></li>
  <li><a class="internal-link" href="{{ '/rockhounding/rocks/sedimentary/' | relative_url }}">Sedimentary</a></li>
  <li><a class="internal-link" href="{{ '/rockhounding/rocks/minerals/' | relative_url }}">Minerals</a></li>

</ul>

<h2>Igneous</h2>
<div class="rock-card-grid">
  {%- assign igneous = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/igneous/'" -%}
  {%- assign igneous = igneous | sort: 'title' -%}
  {%- for n in igneous -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>

<h2>Metamorphic</h2>
<div class="rock-card-grid">
  {%- assign metamorphic = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/metamorphic/'" -%}
  {%- assign metamorphic = metamorphic | sort: 'title' -%}
  {%- for n in metamorphic -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>

<h2>Sedimentary</h2>
<div class="rock-card-grid">
  {%- assign sedimentary = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/sedimentary/'" -%}
  {%- assign sedimentary = sedimentary | sort: 'title' -%}
  {%- for n in sedimentary -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>
