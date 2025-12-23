---
layout: page
title: Blog
summary: Blog index with the latest posts and update dates.
permalink: /blog/
---
<h1>Blog</h1>

<ul>
  {%- assign posts = site.notes | where_exp: "n", "n.path contains '_notes/blog/'" -%}
  {%- assign posts = posts | sort: 'last_modified_at' | reverse -%}
  {%- for note in posts -%}
    <li>
      <a class="internal-link" href="{{ note.url | relative_url }}">{{ note.title }}</a>
      {%- if note.last_modified_at -%}
        <small> — {{ note.last_modified_at | date: "%b %-d, %Y" }}</small>
      {%- endif -%}
    </li>
  {%- endfor -%}
</ul>
