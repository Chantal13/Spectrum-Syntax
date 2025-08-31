---
layout: page
title: Rockhounding Guides
permalink: /rockhounding/guides/
---

<h1>Rockhounding Guides</h1>

<ul>
  {%- assign guide_notes = site.notes | where_exp: "n", "n.path contains '_notes/Rockhounding/Guides/'" -%}
  {%- assign guide_sorted = guide_notes | sort: "title" -%}
  {%- for note in guide_sorted -%}
  <li><a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a></li>
  {%- endfor -%}
</ul>
