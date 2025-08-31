---
layout: page
title: IDLE Champions
permalink: /games/idle-champions/
---

<h1>IDLE Champions</h1>

<h2>Subsections</h2>
<ul>
  <li><a class="internal-link" href="{{ site.baseurl }}/games/idle-champions/events/">Events</a></li>
</ul>

<h2>Notes</h2>
<ul>
  {%- assign ic_notes = site.notes | where_exp: "n", "n.path contains '_notes/Games/IDLE Champions/' and n.path not contains '/Events/'" -%}
  {%- assign ic_sorted = ic_notes | sort: "title" -%}
  {%- for note in ic_sorted -%}
  <li><a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a></li>
  {%- endfor -%}
</ul>
