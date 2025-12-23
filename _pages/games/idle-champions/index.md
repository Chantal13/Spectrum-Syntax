---
layout: page
title: IDLE Champions
summary: Index of IDLE Champions notes, guides, and references.
permalink: /games/idle-champions/
---
<h1>IDLE Champions</h1>

<ul>
  {%- assign notes = site.notes | where_exp: "n", "n.path contains '_notes/notes/games/IDLE Champions/'" -%}
  {%- assign notes = notes | sort: 'title' -%}
  {%- for n in notes -%}
    <li><a class="internal-link" href="{{ n.url | relative_url }}">{{ n.title }}</a></li>
  {%- endfor -%}
</ul>
