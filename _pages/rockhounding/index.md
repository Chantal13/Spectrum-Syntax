---
layout: page
title: Rockhounding
permalink: /rockhounding/
---

<h1>Rockhounding</h1>

<ul>
  {%- assign rh_notes = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/'" -%}
  {%- assign rh_sorted = rh_notes | sort: "title" -%}
  {%- for note in rh_sorted -%}
  <li>
    <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
  </li>
  {%- endfor -%}
</ul>

