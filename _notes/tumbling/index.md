---
title: Tumbling Batches
permalink: /tumbling/
layout: default
---

# Tumbling Batches

{% assign placeholder = '/assets/tumbling/coming-soon.jpg' %}

<div class="tumble">
<table class="tumble-index">
  <thead>
    <tr>
      <th>Photo</th>
      <th>Batch</th>
      <th>Started</th>
      <th>Finished</th>
      <th>Status</th>
      <th>Rocks</th>
      <th>Duration (days)</th>
    </tr>
  </thead>
  <tbody>
  {% assign items = site.tumbles | sort: "date_started" | reverse %}
  {% for t in items %}
    {%- comment -%} Duration (only if both dates exist) {%- endcomment -%}
    {% assign days = "" %}
    {% if t.date_started and t.date_finished %}
      {% assign started_s  = t.date_started  | date: "%s" %}
      {% assign finished_s = t.date_finished | date: "%s" %}
      {% if started_s and finished_s %}
        {% assign seconds = finished_s | minus: started_s %}
        {% assign days = seconds | divided_by: 86400 %}
      {% endif %}
    {% endif %}

    {%- comment -%} Thumbnail: prefer after Stage 4, then burnish, then rough, else placeholder {%- endcomment -%}
    {% assign thumb = t.images.after_stage_4 | default: t.images.after_burnish | default: t.images.rough | default: placeholder %}
    {% assign is_ph = thumb == placeholder %}

    <tr>
      <td class="td-thumb">
        <a href="{{ t.url | relative_url }}" class="thumb-link">
          <img class="t-thumb{% if is_ph %} is-placeholder{% endif %}"
               src="{{ thumb | relative_url }}"
               alt="Batch {{ t.batch | default: t.title }} thumbnail"
               loading="lazy" decoding="async">
        </a>
      </td>

      <td><a class="internal-link" href="{{ t.url | relative_url }}">{{ t.batch | default: t.title }}</a></td>
      <td>{{ t.date_started | default: "—" }}</td>
      <td>{{ t.date_finished | default: "—" }}</td>

      <td>
        {% assign st = t.status | default: 'Pending' %}
        <span class="chip chip-status chip-status--{{ st | downcase | replace: ' ', '-' }}">{{ st }}</span>
      </td>

      <td>
        {% if t.rocks and t.rocks.size > 0 %}
          <span class="chip-row">
            {% for rock in t.rocks %}
              {% assign rock_cls = rock | downcase | replace: ' ', '-' %}
              <span class="chip chip-rock rock-{{ rock_cls }}">{{ rock }}</span>
            {% endfor %}
          </span>
        {% else %}
          —
        {% endif %}
      </td>

      <td>{% if days != "" %}{{ days }}{% else %}—{% endif %}</td>
    </tr>
  {% endfor %}
  </tbody>
</table>
</div>
