---
layout: page
title: Games
summary: Notes and guides grouped by game with links to each game hub.
id:
permalink: /games/
tags:
  - games
---
<p>Notes and guides grouped by game.</p>

{%- assign game_notes = site.notes | where_exp: "n", "n.path contains '_notes/notes/games/' and n.layout == 'page'" -%}
{%- assign game_notes = game_notes | sort: "title" -%}

<ul>
  {%- for note in game_notes -%}
    {%- if note.url != page.url -%}
    <li><a class="internal-link" href="{{ note.url | relative_url }}">{{ note.title }}</a></li>
    {%- endif -%}
  {%- endfor -%}
</ul>
