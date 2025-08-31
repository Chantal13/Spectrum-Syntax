---
layout: page
title: IDLE Champions Events
permalink: /games/idle-champions/events/
---

<h1>IDLE Champions Events</h1>

<ul>
  {%- assign event_notes = site.notes | where_exp: "n", "n.path contains '_notes/Games/IDLE Champions/Events/'" -%}
  {%- assign event_sorted = event_notes | sort: "title" -%}
  {%- for note in event_sorted -%}
  <li><a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a></li>
  {%- endfor -%}
</ul>
