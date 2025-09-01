---
layout: page
title: Minerals
permalink: /rockhounding/rocks/minerals/
---

<h1>Minerals</h1>

<ul>
  {%- assign items = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/rocks/minerals/'" -%}
  {%- assign items = items | sort: 'title' -%}
  {%- for n in items -%}
    <li><a class="internal-link" href="{{ n.url | relative_url }}">{{ n.title }}</a></li>
  {%- endfor -%}
</ul>

