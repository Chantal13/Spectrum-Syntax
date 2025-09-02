---
layout: page
title: Minerals
permalink: /rockhounding/rocks/minerals/
---

<h1>Minerals</h1>

{%- comment -%}
  Group minerals by base mineral. Quartz contains its varieties
  (amethyst, chalcedony, agate, etc.). Agate varieties are grouped
  under the main Agate category.
{%- endcomment -%}

{%- assign root = '_notes/rockhounding/rocks/minerals/' -%}
{%- assign all = site.notes | where_exp: "n", "n.path contains root" -%}
{%- assign base = all | where_exp: "n", "n.path | split: '/' | size == 5" | sort: 'title' -%}

{%- assign quartz_base = base | where: 'title', 'Quartz' -%}
{%- assign other_bases = base | where_exp: "n", "n.title != 'Quartz' and n.title != 'Jasper'" -%}

{%- for b in quartz_base -%}
  <h2>{{ b.title }}</h2>
  {%- assign b_slug = b.path | split: '/' | last | replace: '.md','' -%}
  {%- assign base_dir = root | append: b_slug | append: '/' -%}

  <div class="rock-card-grid">
    {%- comment -%} Immediate children (e.g., Amethyst, Rose/Smoky/Milky Quartz, Aventurine, Tiger's eye) with custom order {%- endcomment -%}
    {%- assign immediate_children = all | where_exp: "n", "n.path contains base_dir and n.path | split: '/' | size == 6" -%}
    {%- assign order_slugs = 'amethyst,rose-quartz,smoky-quartz,milky-quartz,aventurine,tiger-eye' | split: ',' -%}
    {%- for s in order_slugs -%}
      {%- assign match_path = base_dir | append: s | append: '.md' -%}
      {%- assign match = immediate_children | where_exp: "n", "n.path == match_path" -%}
      {%- for n in match -%}
        {% include rock-card.html rock=n %}
      {%- endfor -%}
    {%- endfor -%}
    {%- capture ordered_joined -%},amethyst,rose-quartz,smoky-quartz,milky-quartz,aventurine,tiger-eye,{%- endcapture -%}
    {%- assign remaining = immediate_children | sort: 'title' -%}
    {%- for n in remaining -%}
      {%- assign slug = n.path | split:'/' | last | replace: '.md','' -%}
      {%- unless ordered_joined contains ',' | append: slug | append: ',' -%}
        {% include rock-card.html rock=n %}
      {%- endunless -%}
    {%- endfor -%}

    {%- comment -%} Immediate subcategory indexes (e.g., Chalcedony) {%- endcomment -%}
    {%- assign sub_indexes = all | where_exp: "n", "n.path contains base_dir and n.path | split: '/' | size == 7 and n.path | split:'/' | last == 'index.md'" | sort: 'title' -%}
    {%- for n in sub_indexes -%}
      {% include rock-card.html rock=n %}
    {%- endfor -%}

    {%- comment -%} Include the main Agate page under Quartz {%- endcomment -%}
    {%- assign agate_dir = chalcedony_dir | append: 'agate/' -%}
    {%- assign agate_main_path = agate_dir | append: 'agate.md' -%}
    {%- assign agate_main = all | where_exp: "n", "n.path == agate_main_path" -%}
    {%- for n in agate_main -%}
      {% include rock-card.html rock=n %}
    {%- endfor -%}
  </div>

  {%- comment -%} Agate varieties grouped under Agate {%- endcomment -%}
  <h3>Agate Varieties</h3>
  <div class="rock-card-grid">
    {%- assign chalcedony_items = all | where_exp: "n", "n.path contains chalcedony_dir" -%}
    {%- assign agate_varieties = chalcedony_items | where_exp: "n", "(n.path contains agate_dir and n.path | split:'/' | last != 'agate.md' and n.path | split:'/' | last != 'index.md') or (n.title contains 'Agate' and n.path contains chalcedony_dir and n.path | split:'/' | size == 7)" -%}
    {%- assign agate_varieties = agate_varieties | sort: 'title' -%}
    {%- for n in agate_varieties -%}
      {% include rock-card.html rock=n %}
    {%- endfor -%}
  </div>

  {%- comment -%} Chalcedony direct children (non-agate varieties like Onyx, Heliotrope) {%- endcomment -%}
  <h3>Chalcedony Varieties</h3>
  <div class="rock-card-grid">
    {%- assign chalcedony_children = all | where_exp: "n", "n.path contains chalcedony_dir and n.path | split:'/' | size == 7 and n.path | split:'/' | last != 'index.md'" | sort: 'title' -%}
    {%- for n in chalcedony_children -%}
      {%- unless n.title contains 'Agate' -%}
        {% include rock-card.html rock=n %}
      {%- endunless -%}
    {%- endfor -%}
  </div>

  {%- comment -%} Jasper main page and grouped Jasper varieties {%- endcomment -%}
  <h3>Jasper</h3>
  <div class="rock-card-grid">
    {%- assign jasper_main = site.notes | where: 'title', 'Jasper' -%}
    {%- for n in jasper_main -%}
      {% include rock-card.html rock=n %}
    {%- endfor -%}
  </div>

  <h3>Jasper Varieties</h3>
  <div class="rock-card-grid">
    {%- assign jasper_dir = base_dir | append: 'jasper/' -%}
    {%- assign jasper_varieties = all | where_exp: "n", "n.path contains jasper_dir and n.path | split:'/' | size == 7 and n.path | split:'/' | last != 'index.md'" | sort: 'title' -%}
    {%- for n in jasper_varieties -%}
      {% include rock-card.html rock=n %}
    {%- endfor -%}
  </div>
{%- endfor -%}

{%- for b in other_bases -%}
  <h2>{{ b.title }}</h2>
  {%- assign b_slug = b.path | split: '/' | last | replace: '.md','' -%}
  {%- assign base_dir = root | append: b_slug | append: '/' -%}

  <div class="rock-card-grid">
    {%- assign immediate_children = all | where_exp: "n", "n.path contains base_dir and n.path | split: '/' | size == 6" | sort: 'title' -%}
    {%- for n in immediate_children -%}
      {% include rock-card.html rock=n %}
    {%- endfor -%}
  </div>
  {%- assign deeper_pages = all | where_exp: "n", "n.path contains base_dir and n.path | split:'/' | size >= 7 and n.path | split:'/' | last != 'index.md'" -%}
  {%- if deeper_pages and deeper_pages.size > 0 -%}
    <h3>Varieties</h3>
    <div class="rock-card-grid">
      {%- assign deeper_pages = deeper_pages | sort: 'title' -%}
      {%- for n in deeper_pages -%}
        {% include rock-card.html rock=n %}
      {%- endfor -%}
    </div>
  {%- endif -%}
{%- endfor -%}
