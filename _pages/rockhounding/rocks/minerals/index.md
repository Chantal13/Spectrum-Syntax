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
{%- assign all_sorted = all | sort: 'title' -%}

{%- for b in all_sorted -%}
  {%- assign rel_b = b.path | remove: root -%}
  {%- if rel_b contains '/' -%}
    {%- continue -%}
  {%- endif -%}
  <h2>{{ b.title }}</h2>
  {%- assign b_slug = b.path | split: '/' | last | replace: '.md','' -%}
  {%- assign base_dir = root | append: b_slug | append: '/' -%}

  {%- comment -%} Immediate children (one level under the base) {%- endcomment -%}
  <div class="rock-card-grid">
    {%- for n in all_sorted -%}
      {%- if n.path contains base_dir -%}
        {%- assign rel = n.path | remove: base_dir -%}
        {%- assign last = n.path | split:'/' | last -%}
        {%- unless last == 'index.md' -%}
          {%- unless rel contains '/' -%}
            {% include rock-card.html rock=n %}
          {%- endunless -%}
        {%- endunless -%}
      {%- endif -%}
    {%- endfor -%}
  </div>

  {%- comment -%}
    Discover first-level subcategory slugs under this base by
    inspecting the next path segment after base_dir.
  {%- endcomment -%}
  {%- assign sub_slugs = '' -%}
  {%- for n in all -%}
    {%- if n.path contains base_dir -%}
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
    {%- comment -%} Build immediate children list for this subcategory {%- endcomment -%}
    {%- assign s_immediate_markup = '' -%}
    {%- for n in all_sorted -%}
      {%- if n.path contains s_dir -%}
        {%- assign rel = n.path | remove: s_dir -%}
        {%- assign last = n.path | split:'/' | last -%}
        {%- unless last == 'index.md' -%}
          {%- unless rel contains '/' -%}
            {%- capture s_immediate_markup -%}{{ s_immediate_markup }}{% include rock-card.html rock=n %}{%- endcapture -%}
          {%- endunless -%}
        {%- endunless -%}
      {%- endif -%}
    {%- endfor -%}

    {%- comment -%}
      Discover second-level subcategory slugs under this subcategory.
    {%- endcomment -%}
    {%- assign sub2_slugs = '' -%}
    {%- for n2 in all -%}
      {%- if n2.path contains s_dir -%}
        {%- assign rel2 = n2.path | remove: s_dir -%}
        {%- if rel2 contains '/' -%}
          {%- assign first2 = rel2 | split:'/' | first -%}
          {%- unless first2 contains '.md' -%}
            {%- capture needle2 -%}|{{ first2 }}|{%- endcapture -%}
            {%- unless sub2_slugs contains needle2 -%}
              {%- capture sub2_slugs -%}{{ sub2_slugs }}{{ needle2 }}{%- endcapture -%}
            {%- endunless -%}
          {%- endunless -%}
        {%- endif -%}
      {%- endif -%}
    {%- endfor -%}
    {%- assign sub2_slugs = sub2_slugs | replace: '||', '|' -%}
    {%- assign sub2_slugs = sub2_slugs | split: '|' | sort -%}

    {%- comment -%}
      Render subcategory-level varieties, excluding items that will be
      grouped under any deeper sub-subcategory (by title match).
    {%- endcomment -%}
    {%- capture s_var_markup -%}
      {%- for n in all_sorted -%}
        {%- if n.path contains s_dir -%}
        {%- assign rel = n.path | remove: s_dir -%}
        {%- unless rel contains '/' -%}
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
        {%- endunless -%}
        {%- endif -%}
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
        {%- for n in all_sorted -%}
          {%- if n.path contains t_dir -%}
            {%- assign rel = n.path | remove: t_dir -%}
            {%- unless rel contains '/' -%}
              {%- assign last = n.path | split:'/' | last -%}
              {%- unless last == 'index.md' or last == t_slug | append: '.md' -%}
                {% include rock-card.html rock=n %}
              {%- endunless -%}
            {%- endunless -%}
          {%- endif -%}
        {%- endfor -%}

        {%- comment -%} Also pull in stray items like "Moss Agate" {%- endcomment -%}
        {%- for n in all_sorted -%}
          {%- if n.path contains s_dir -%}
            {%- assign rel = n.path | remove: s_dir -%}
            {%- unless rel contains '/' -%}
              {%- assign last = n.path | split:'/' | last -%}
              {%- unless last == 'index.md' -%}
                {%- assign t_label = t_slug | replace: '-', ' ' | capitalize -%}
                {%- if n.title contains t_label -%}
                  {% include rock-card.html rock=n %}
                {%- endif -%}
              {%- endunless -%}
            {%- endunless -%}
          {%- endif -%}
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
