---
layout: page
title: Rocks
permalink: /rockhounding/rocks/
---

<h1>Rocks</h1>

<h2>By Category</h2>
<ul>
  <li><a class="internal-link" href="{{ '/rockhounding/rocks/category/igneous/' | relative_url }}">Igneous</a></li>
  <li><a class="internal-link" href="{{ '/rockhounding/rocks/category/metamorphic/' | relative_url }}">Metamorphic</a></li>
  <li><a class="internal-link" href="{{ '/rockhounding/rocks/category/sedimentary/' | relative_url }}">Sedimentary</a></li>
  <li><a class="internal-link" href="{{ '/rockhounding/rocks/minerals/' | relative_url }}">Minerals</a></li>
  
</ul>

<h2>All Rocks</h2>
<ul>
  {%- assign items = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/'" -%}
  {%- assign items = items | reject: 'path', '_notes/rockhounding/rocks/category/index.md' -%}
  {%- assign items = items | where_exp: "n", "n.path contains '/rocks/'" -%}
  {%- assign items = items | sort: 'title' -%}
  {%- for n in items -%}
    {%- unless n.path contains '/minerals/' or n.path contains '/category/' -%}
      <li><a class="internal-link" href="{{ n.url | relative_url }}">{{ n.title }}</a></li>
    {%- endunless -%}
  {%- endfor -%}
</ul>
