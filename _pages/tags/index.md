---
layout: page
title: Tags
summary: Tag index that groups notes by topic.
permalink: /tags/
---
{%- assign tag_list = "" -%}
{%- assign tagged_docs = site.notes | where_exp: "n", "n.tags != nil" -%}
{%- for doc in tagged_docs -%}
  {%- for tag in doc.tags -%}
    {%- assign tag_list = tag_list | append: tag | append: "," -%}
  {%- endfor -%}
{%- endfor -%}
{%- assign tags = tag_list | split: "," | uniq | sort -%}

<p>Tags across notes.</p>

{% for tag in tags %}
  {%- assign tag_name = tag | downcase -%}
  {%- if tag_name != "" -%}
  <section id="{{ tag_name | slugify }}">
    <h2>#{{ tag_name }}</h2>
    <ul>
      {%- for doc in tagged_docs -%}
        {%- if doc.tags contains tag -%}
        <li><a class="internal-link" href="{{ doc.url | relative_url }}">{{ doc.title }}</a></li>
        {%- endif -%}
      {%- endfor -%}
    </ul>
  </section>
  {%- endif -%}
{% endfor %}
