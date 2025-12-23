---
layout: page
title: Guides
summary: Rockhounding how-to guides, safety notes, and identification help.
permalink: /rockhounding/guides/
---
<h1>Guides</h1>

<ul>
  {%- assign notes = site.notes | where_exp: "n", "n.path contains '_notes/notes/rockhounding/guides/'" -%}
  {%- assign notes = notes | sort: 'title' -%}
  {%- for n in notes -%}
    <li><a class="internal-link" href="{{ n.url | relative_url }}">{{ n.title }}</a></li>
  {%- endfor -%}
</ul>
