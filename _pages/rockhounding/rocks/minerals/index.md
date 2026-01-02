---
layout: page
title: Minerals
summary: Mineral notes with quick links and ID cards.
permalink: /rockhounding/rocks/minerals/
breadcrumbs:
  - title: Rockhounding
    url: /rockhounding/
  - title: Rocks & Minerals
    url: /rockhounding/rocks/
---
<h1>Minerals</h1>

<div class="chips">
  <a class="chip internal-link" href="{{ '/rockhounding/rocks/' | relative_url }}#minerals">Back to Rocks &amp; Minerals</a>
  <a class="chip internal-link" href="{{ '/notes/rockhounding/rocks/minerals/quartz/' | relative_url }}">Quartz</a>
  <a class="chip internal-link" href="{{ '/notes/rockhounding/rocks/minerals/chalcedony/' | relative_url }}">Chalcedony</a>
  <a class="chip internal-link" href="{{ '/notes/rockhounding/rocks/minerals/feldspar/' | relative_url }}">Feldspar</a>
  <a class="chip internal-link" href="{{ '/notes/rockhounding/rocks/minerals/garnet/' | relative_url }}">Garnet</a>
  <a class="chip internal-link" href="{{ '/notes/rockhounding/rocks/minerals/mica/' | relative_url }}">Mica</a>
  <a class="chip internal-link" href="{{ '/notes/rockhounding/rocks/minerals/calcite/' | relative_url }}">Calcite</a>
  <a class="chip internal-link" href="{{ '/notes/rockhounding/rocks/minerals/jasper/' | relative_url }}">Jasper</a>
</div>

<div class="rock-card-grid">
  {%- assign minerals = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/rocks/minerals/'" -%}
  {%- assign minerals = minerals | sort: 'title' -%}
  {%- for n in minerals -%}
    {%- assign last = n.path | split: '/' | last -%}
    {%- unless last == 'index.md' -%}
      {% include rock-card.html rock=n %}
    {%- endunless -%}
  {%- endfor -%}
</div>
