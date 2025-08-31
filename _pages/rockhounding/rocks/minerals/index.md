---
layout: page
title: Minerals
permalink: /rockhounding/rocks/minerals/
---

<h1>Minerals</h1>

<ul>
  {%- assign mineral_notes = site.notes | where_exp: "n", "n.path contains '_notes/Rockhounding/Rocks/Minerals/'" -%}
  {%- assign mineral_sorted = mineral_notes | sort: "title" -%}
  {%- for note in mineral_sorted -%}
  <li><a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a></li>
  {%- endfor -%}
</ul>
