---
layout: page
title: Sedimentary Rocks
permalink: /rockhounding/rocks/sedimentary/
aliases:
  - sedimentary
---

<h1>Sedimentary Rocks</h1>

<ul>
  {%- assign notes = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/sedimentary/'" -%}
  {%- assign notes = notes | sort: 'title' -%}
  {%- for n in notes -%}
    <li><a class="internal-link" href="{{ n.url | relative_url | uri_escape }}">{{ n.title }}</a></li>
  {%- endfor -%}
</ul>
