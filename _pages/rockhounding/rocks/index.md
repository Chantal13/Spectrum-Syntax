---
layout: page
title: Rocks & Minerals
permalink: /rockhounding/rocks/
---

<h1>Rocks &amp; Minerals</h1>

{%- comment -%} Curated quick links to top minerals {%- endcomment -%}
<div class="chips">
  <a class="chip" href="{{ '/rockhounding/rocks/minerals/quartz/'    | relative_url }}">Quartz</a>
  <a class="chip" href="{{ '/rockhounding/rocks/minerals/feldspar/'  | relative_url }}">Feldspar</a>
  <a class="chip" href="{{ '/rockhounding/rocks/minerals/garnet/'    | relative_url }}">Garnet</a>
  <a class="chip" href="{{ '/rockhounding/rocks/minerals/jasper/'    | relative_url }}">Jasper</a>
</div>

<h2>Igneous</h2>
<div class="rock-card-grid">
  {%- assign igneous = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/igneous/'" -%}
  {%- assign igneous = igneous | sort: 'title' -%}
  {%- for n in igneous -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>

<h2>Minerals</h2>
{%- comment -%} Quick links to base mineral categories {%- endcomment -%}
{%- assign minerals_root = '_notes/rockhounding/rocks/minerals/' -%}
{%- assign all_minerals = site.notes | where_exp: "n", "n.path contains minerals_root" -%}
{%- assign base_minerals = '' -%}
{%- for m in all_minerals -%}
  {%- assign rel = m.path | remove: minerals_root -%}
  {%- unless rel contains '/' -%}
    {%- capture base_minerals -%}{{ base_minerals }}|{{ m.url }}::{{ m.title }}{%- endcapture -%}
  {%- endunless -%}
{%- endfor -%}
{%- assign base_minerals = base_minerals | split: '|' | sort -%}
{%- if base_minerals.size > 0 -%}
  <div class="chips">
    {%- for item in base_minerals -%}
      {%- if item != '' -%}
        {%- assign parts = item | split: '::' -%}
        <a class="chip" href="{{ parts[0] | relative_url }}">{{ parts[1] }}</a>
      {%- endif -%}
    {%- endfor -%}
  </div>
{%- endif -%}
<div class="rock-card-grid">
  {%- assign minerals = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/minerals/'" -%}
  {%- assign minerals = minerals | sort: 'title' -%}
  {%- for n in minerals -%}
    {%- assign last = n.path | split: '/' | last -%}
    {%- unless last == 'index.md' -%}
      {% include rock-card.html rock=n %}
    {%- endunless -%}
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
