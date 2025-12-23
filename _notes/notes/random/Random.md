---
layout: page
date: 2025-12-21
title: Random
summary: Miscellaneous notes that do not fit a specific section yet.
id:
permalink:
---
<ul>
  {%- assign notes = site.notes | where_exp: "n", "n.path contains '_notes/notes/random/'" -%}
  {%- assign notes = notes | sort: 'title' -%}
  {%- for n in notes -%}
    {%- if n.url != page.url -%}
      <li><a class="internal-link" href="{{ n.url | relative_url }}">{{ n.title | default: n.basename_without_ext }}</a></li>
    {%- endif -%}
  {%- endfor -%}
</ul>
