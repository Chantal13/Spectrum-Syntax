---
layout: page
title: Rocks
permalink: /rockhounding/rocks/
---

<h1>Rocks</h1>

<h2>Subsections</h2>
<ul>
  <li><a class="internal-link" href="{{ site.baseurl }}/rockhounding/rocks/categories/">Categories</a></li>
  <li><a class="internal-link" href="{{ site.baseurl }}/rockhounding/rocks/minerals/">Minerals</a></li>
</ul>

<h2>Rock Notes</h2>
<ul>
  {%- assign rock_notes = site.notes | where_exp: "n", "n.path contains '_notes/Rockhounding/Rocks/' and n.path not contains '/Minerals/' and n.path not contains '/Categories/'" -%}
  {%- assign rock_sorted = rock_notes | sort: "title" -%}
  {%- for note in rock_sorted -%}
  <li><a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a></li>
  {%- endfor -%}
</ul>
