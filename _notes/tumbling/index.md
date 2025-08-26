---
title: Tumbling Batches
permalink: /tumbling/
layout: default
---

# Tumbling Batches

{% assign items = site.notes 
  | where_exp: "d", "d.relative_path contains '/tumble_logs/'" 
  | sort: "date_started" 
  | reverse %}

<div class="tumble">
<table>
  <thead>
    <tr>
      <th>Batch</th>
      <th>Started</th>
      <th>Finished</th>
      <th>Status</th>
      <th>Rocks</th>
      <th>Duration (days)</th>
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
      <tr>
        <td><a href="{{ t.url | relative_url }}">{{ t.batch | default: t.title }}</a></td>
        <td>{{ t.date_started | default: "—" }}</td>
        <td>{{ t.date_finished | default: "—" }}</td>
        <td>{{ t.status | default: "—" }}</td>
        <td>{% if t.rocks %}{{ t.rocks | join: ", " }}{% else %}—{% endif %}</td>
        <td>{% if days != "" %}{{ days }}{% else %}—{% endif %}</td>
      </tr>
    {% endfor %}
  {% else %}
    <tr><td colspan="6">
      No batches found. Put markdown files in <code>/tumble_logs/</code> with frontmatter and <code>layout: tumble</code>.
    </td></tr>
  {% endif %}
  </tbody>
</table>
</div>