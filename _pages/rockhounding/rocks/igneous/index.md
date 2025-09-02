---
layout: page
title: Igneous Rocks
permalink: /rockhounding/rocks/igneous/
---

<h1>Igneous Rocks</h1>

<ul>
  {%- assign notes = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/igneous/'" -%}
  {%- assign notes = notes | sort: 'title' -%}
  {%- for n in notes -%}
    <li><a class="internal-link" href="{{ n.url | relative_url | uri_escape }}">{{ n.title }}</a></li>
  {%- endfor -%}
</ul>

