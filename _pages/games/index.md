---
layout: page
title: Games
permalink: /games/
---

<h1>Games</h1>

<ul>
  {%- assign games_notes = site.notes | where_exp: "n", "n.path contains '_notes/games/'" -%}
  {%- assign games_sorted = games_notes | sort: "title" -%}
  {%- for note in games_sorted -%}
  <li>
    <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
  </li>
  {%- endfor -%}
</ul>

