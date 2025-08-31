---
layout: page
title: Rock Categories
permalink: /rockhounding/rocks/categories/
---

<h1>Rock Categories</h1>

<ul>
  {%- assign cat_notes = site.notes | where_exp: "n", "n.path contains '_notes/Rockhounding/Rocks/Categories/'" -%}
  {%- assign cat_sorted = cat_notes | sort: "title" -%}
  {%- for note in cat_sorted -%}
  <li><a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a></li>
  {%- endfor -%}
</ul>
