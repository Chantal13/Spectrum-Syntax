---
layout: page
title: Tags
summary: Tag index that groups notes by topic.
permalink: /tags/
---
{%- assign tagged_docs = site.notes | where_exp: "n", "n.tags != nil" -%}
{%- assign tag_graph = tagged_docs | build_note_tag_graph -%}
{%- assign tag_nodes = tag_graph["tag_nodes"] -%}

{%- assign max_count = 0 -%}
{%- for tag in tag_nodes -%}
  {%- if tag.count > max_count -%}
    {%- assign max_count = tag.count -%}
  {%- endif -%}
{%- endfor -%}
{%- if max_count == 0 -%}
  {%- assign max_count = 1 -%}
{%- endif -%}

{%- assign tag_groups = tag_nodes | group_by: "root" | sort: "name" -%}

<p>Tags across notes, sized by how often they appear (including nested tags).</p>

{% for group in tag_groups %}
  <section class="tag-group" id="{{ group.name | slugify }}">
    <h2>{{ group.name }}</h2>
    <div class="tag-cloud">
      {%- assign sorted_tags = group.items | sort_natural: "full_label" -%}
      {%- for tag in sorted_tags -%}
        {%- assign weight = tag.count | times: 1.0 | divided_by: max_count -%}
        <a class="tag-chip" id="{{ tag.slug }}" href="{{ tag.path }}" style="--tag-weight: {{ weight | default: 0 }};">
          {{ tag.full_label }}
          <span class="tag-chip__count" aria-hidden="true">{{ tag.count }}</span>
          <span class="sr-only">({{ tag.count }} uses)</span>
        </a>
      {%- endfor -%}
    </div>
  </section>
{% endfor %}
