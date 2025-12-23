---
layout: page
title: Rocks & Minerals
summary: Index of rock and mineral notes with category shortcuts and cards.
permalink: /rockhounding/rocks/
---
<h1>Rocks &amp; Minerals</h1>
<p>I'm slowly working on building this section. As I build my field log and tumble rocks, I will replace many of the Wikimedia Commons images I used as placeholders.</p>

{%- comment -%} Quick category shortcuts {%- endcomment -%}
<div class="chips" style="margin-bottom:.5rem">
  <a class="chip internal-link" href="#igneous">Igneous</a>
  <a class="chip internal-link" href="#metamorphic">Metamorphic</a>
  <a class="chip internal-link" href="#sedimentary">Sedimentary</a>
  <a class="chip internal-link" href="#minerals">Minerals</a>
  <a class="chip internal-link" href="{{ '/rockhounding/field-log/' | relative_url }}">Field Log</a>
</div>

{%- comment -%} Curated quick links to top minerals {%- endcomment -%}
<div class="chips">
  <a class="chip" href="{{ '/notes/rockhounding/rocks/minerals/quartz/'    | relative_url }}">Quartz</a>
  <a class="chip" href="{{ '/notes/rockhounding/rocks/minerals/feldspar/'  | relative_url }}">Feldspar</a>
  <a class="chip" href="{{ '/notes/rockhounding/rocks/minerals/garnet/'    | relative_url }}">Garnet</a>
  <a class="chip" href="{{ '/notes/rockhounding/rocks/minerals/jasper/'    | relative_url }}">Jasper</a>
 </div>

<h2 id="igneous">Igneous</h2>
<div class="rock-card-grid">
  {%- assign igneous = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/rocks/igneous/'" -%}
  {%- assign igneous = igneous | sort: 'title' -%}
  {%- for n in igneous -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>

<h2 id="minerals">Minerals</h2>
{%- comment -%} Quick links to base mineral categories {%- endcomment -%}
{%- assign minerals_root = '_notes/notes/rockhounding/rocks/minerals/' -%}
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
  {%- assign minerals = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/rocks/minerals/'" -%}
  {%- assign minerals = minerals | sort: 'title' -%}
  {%- for n in minerals -%}
    {%- assign last = n.path | split: '/' | last -%}
    {%- unless last == 'index.md' -%}
      {% include rock-card.html rock=n %}
    {%- endunless -%}
  {%- endfor -%}
  
</div>

<h2 id="metamorphic">Metamorphic</h2>
<div class="rock-card-grid">
  {%- assign metamorphic = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/rocks/metamorphic/'" -%}
  {%- assign metamorphic = metamorphic | sort: 'title' -%}
  {%- for n in metamorphic -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>

<h2 id="sedimentary">Sedimentary</h2>
<div class="rock-card-grid">
  {%- assign sedimentary = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/rocks/sedimentary/'" -%}
  {%- assign sedimentary = sedimentary | sort: 'title' -%}
  {%- for n in sedimentary -%}
    {% include rock-card.html rock=n %}
  {%- endfor -%}
</div>
