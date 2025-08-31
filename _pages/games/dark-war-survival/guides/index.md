---
layout: page
title: Dark War Survival Guides
permalink: /games/dark-war-survival/guides/
---

<h1>Dark War Survival Guides</h1>

<ul>
  {%- assign guide_notes = site.notes | where_exp: "n", "n.path contains '_notes/Games/Dark War Survival/Guides/'" -%}
  {%- assign guide_sorted = guide_notes | sort: "title" -%}
  {%- for note in guide_sorted -%}
  <li><a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a></li>
  {%- endfor -%}
</ul>
