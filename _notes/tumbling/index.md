---
title: Tumbling Batches
permalink: /tumbling/
layout: default
---

# Tumbling Batches

{% assign items = site.notes
  | where_exp: "d", "d.relative_path contains '/tumble_logs/'"
  | sort: "date_started" | reverse %}

<div class="tumble">
<table class="tumble-table">
  <thead>
    <tr>
      <th>Batch</th>
      <th>Started</th>
      <th>Finished</th>
      <th>Status</th>
      <th>Rocks</th>
      <th class="num">Duration (days)</th>
    </tr>
  </thead>
  <tbody>
  {% if items and items.size > 0 %}
    {% for t in items %}
      {% assign days = "" %}
      {% if t.date_started and t.date_finished %}
        {% assign started_s  = t.date_started  | date: "%s" %}
        {% assign finished_s = t.date_finished | date: "%s" %}
        {% assign seconds = finished_s | minus: started_s %}
        {% assign days = seconds | divided_by: 86400 %}
      {% endif %}

      {% assign status_txt = t.status | default: "" %}
      {% assign status_slug = status_txt | downcase | replace: " ", "-" %}

      <tr>
        <td data-label="Batch">
          <a href="{{ t.url | relative_url }}">{{ t.batch | default: t.title }}</a>
        </td>
        <td data-label="Started" class="mono">
          {% if t.date_started %}{{ t.date_started | date: "%Y-%m-%d" }}{% else %}<span class="muted">—</span>{% endif %}
        </td>
        <td data-label="Finished" class="mono">
          {% if t.date_finished %}{{ t.date_finished | date: "%Y-%m-%d" }}{% else %}<span class="muted">—</span>{% endif %}
        </td>
        <td data-label="Status">
          {% if status_txt != "" %}
            <span class="badge {{ status_slug }}">{{ status_txt }}</span>
          {% else %}
            <span class="muted">—</span>
          {% endif %}
        </td>
        <td data-label="Rocks">
          {% if t.rocks %}
            {% if t.rocks.size > 0 %}{{ t.rocks | join: ", " }}{% else %}<span class="muted">—</span>{% endif %}
          {% elsif t.rocks_string %}
            {{ t.rocks_string }}
          {% else %}
            <span class="muted">—</span>
          {% endif %}
        </td>
        <td data-label="Duration (days)" class="num mono">
          {% if days != "" %}{{ days }}{% else %}<span class="muted">—</span>{% endif %}
        </td>
      </tr>
    {% endfor %}
  {% else %}
    <tr><td colspan="6" class="muted">
      No batches found. Put markdown files in <code>_notes/tumble_logs/</code> with frontmatter and <code>layout: tumble</code>.
    </td></tr>
  {% endif %}
  </tbody>
</table>
</div>
