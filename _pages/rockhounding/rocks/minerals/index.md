---
layout: page
title: Minerals
permalink: /rockhounding/rocks/minerals/
---

<h1>Minerals</h1>

{%- comment -%}
  Generic grouping by path depth using Liquid.
  - Base minerals: files directly under root
  - Subcategories: first-level folders under a base
  - Varieties: files directly under a subcategory; deeper folders get
    their own "<Subcategory> Varieties" sections
  Example: Quartz → Chalcedony → Agate → Agate Varieties
{%- endcomment -%}

{%- assign root = '_notes/rockhounding/rocks/minerals/' -%}
{%- assign all = site.notes | where_exp: "n", "n.path contains root" -%}
{%- comment -%}
  Base minerals are files directly under the root directory
{%- endcomment -%}
{%- assign base = all | where_exp: "n", "n.path | remove: root | split: '/' | size == 1" | sort: 'title' -%}

{%- for b in base -%}
  <h2>{{ b.title }}</h2>
  {%- assign b_slug = b.path | split: '/' | last | replace: '.md','' -%}
  {%- assign base_dir = root | append: b_slug | append: '/' -%}

  {%- comment -%} Immediate children (one level under the base) {%- endcomment -%}
  <div class="rock-card-grid">
    {%- assign immediate_children = all | where_exp: "n", "n.path contains base_dir and n.path | remove: base_dir | split: '/' | size == 1" | sort: 'title' -%}
    {%- for n in immediate_children -%}
      {%- assign last = n.path | split:'/' | last -%}
      {%- unless last == 'index.md' -%}
        {% include rock-card.html rock=n %}
      {%- endunless -%}
    {%- endfor -%}
  </div>

  {%- comment -%}
    Discover first-level subcategory slugs under this base by
    inspecting the next path segment after base_dir.
  {%- endcomment -%}
  {%- assign sub_slugs = '' -%}
  {%- assign under_base = all | where_exp: "n", "n.path contains base_dir" -%}
  {%- for n in under_base -%}
    {%- assign rel = n.path | remove: base_dir -%}
    {%- if rel contains '/' -%}
      {%- assign first_seg = rel | split:'/' | first -%}
      {%- unless first_seg contains '.md' -%}
        {%- capture needle -%}|{{ first_seg }}|{%- endcapture -%}
        {%- unless sub_slugs contains needle -%}
          {%- capture sub_slugs -%}{{ sub_slugs }}{{ needle }}{%- endcapture -%}
        {%- endunless -%}
      {%- endunless -%}
    {%- endif -%}
  {%- endfor -%}
  {%- assign sub_slugs = sub_slugs | replace: '||', '|' -%}
  {%- assign sub_slugs = sub_slugs | split: '|' | sort -%}

  {%- for s_slug in sub_slugs -%}
    {%- unless s_slug == '' -%}
    {%- assign s_dir = base_dir | append: s_slug | append: '/' -%}
    {%- assign s_index_path = s_dir | append: 'index.md' -%}
    {%- assign s_index = all | where_exp: "n", "n.path == s_index_path" -%}
    {%- if s_index and s_index.size > 0 -%}
      {%- assign s_title = s_index.first.title -%}
    {%- else -%}
      {%- assign s_title = s_slug | replace: '-', ' ' | capitalize -%}
    {%- endif -%}

    <h3>{{ s_title }}</h3>
    {%- comment -%} Optional: show the subcategory index card if it exists {%- endcomment -%}
    {%- if s_index and s_index.size > 0 -%}
      <div class="rock-card-grid">
        {% include rock-card.html rock=s_index.first %}
      </div>
    {%- endif -%}

    {%- comment -%} Direct children of the subcategory (Varieties at this level) {%- endcomment -%}
    {%- assign s_immediate = all | where_exp: "n", "n.path contains s_dir and n.path | remove: s_dir | split:'/' | size == 1" | sort: 'title' -%}

    {%- comment -%}
      Discover second-level subcategory slugs under this subcategory.
    {%- endcomment -%}
    {%- assign sub2_slugs = '' -%}
    {%- assign under_s = all | where_exp: "n", "n.path contains s_dir and n.path | remove: s_dir | split:'/' | size >= 2" -%}
    {%- for n2 in under_s -%}
      {%- assign rel2 = n2.path | remove: s_dir -%}
      {%- assign first2 = rel2 | split:'/' | first -%}
      {%- unless first2 contains '.md' -%}
        {%- capture needle2 -%}|{{ first2 }}|{%- endcapture -%}
        {%- unless sub2_slugs contains needle2 -%}
          {%- capture sub2_slugs -%}{{ sub2_slugs }}{{ needle2 }}{%- endcapture -%}
        {%- endunless -%}
      {%- endunless -%}
    {%- endfor -%}
    {%- assign sub2_slugs = sub2_slugs | replace: '||', '|' -%}
    {%- assign sub2_slugs = sub2_slugs | split: '|' | sort -%}

    {%- comment -%}
      Render subcategory-level varieties, excluding items that will be
      grouped under any deeper sub-subcategory (by title match).
    {%- endcomment -%}
    {%- capture s_var_markup -%}
      {%- for n in s_immediate -%}
        {%- assign last = n.path | split:'/' | last -%}
        {%- unless last == 'index.md' -%}
          {%- assign exclude = false -%}
          {%- for t_slug in sub2_slugs -%}
            {%- assign t_label = t_slug | replace: '-', ' ' | capitalize -%}
            {%- if n.title contains t_label -%}
              {%- assign exclude = true -%}
            {%- endif -%}
          {%- endfor -%}
          {%- unless exclude -%}
            {% include rock-card.html rock=n %}
          {%- endunless -%}
        {%- endunless -%}
      {%- endfor -%}
    {%- endcapture -%}
    {%- if s_var_markup contains 'rock-card' -%}
      <h4>{{ s_title }} Varieties</h4>
      <div class="rock-card-grid">
        {{ s_var_markup }}
      </div>
    {%- endif -%}

    {%- comment -%}
      For each deeper subcategory (e.g., Agate), render its varieties.
      Also include any immediate children of the parent subcategory whose
      titles contain the deeper subcategory name (e.g., Moss Agate).
    {%- endcomment -%}
    {%- for t_slug in sub2_slugs -%}
      {%- unless t_slug == '' -%}
      {%- assign t_dir = s_dir | append: t_slug | append: '/' -%}
      {%- assign t_label = t_slug | replace: '-', ' ' | capitalize -%}

      {%- capture t_var_markup -%}
        {%- assign t_immediate = all | where_exp: "n", "n.path contains t_dir and n.path | remove: t_dir | split:'/' | size == 1" | sort: 'title' -%}
        {%- for n in t_immediate -%}
          {%- assign last = n.path | split:'/' | last -%}
          {%- unless last == 'index.md' or last == t_slug | append: '.md' -%}
            {% include rock-card.html rock=n %}
          {%- endunless -%}
        {%- endfor -%}

        {%- comment -%} Also pull in stray items like "Moss Agate" {%- endcomment -%}
        {%- assign stray = all | where_exp: "n", "n.path contains s_dir and n.path | remove: s_dir | split:'/' | size == 1 and n.title contains t_label" | sort: 'title' -%}
        {%- for n in stray -%}
          {%- assign last = n.path | split:'/' | last -%}
          {%- unless last == 'index.md' -%}
            {% include rock-card.html rock=n %}
          {%- endunless -%}
        {%- endfor -%}
      {%- endcapture -%}

      {%- if t_var_markup contains 'rock-card' -%}
        <h4>{{ t_label }} Varieties</h4>
        <div class="rock-card-grid">
          {{ t_var_markup }}
        </div>
      {%- endif -%}
      {%- endunless -%}
    {%- endfor -%}
    {%- endunless -%}
  {%- endfor -%}
{%- endfor -%}
