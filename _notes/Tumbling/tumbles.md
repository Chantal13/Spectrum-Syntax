---
title: Tumbling Batches
permalink: /tumbling/
layout: default
---

# Tumbling Batches

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
  {% assign items = site.tumbles | sort: "date_started" | reverse %}
  {% for t in items %}
    {% assign started_s  = t.date_started  | date: "%s" %}
    {% assign finished_s = t.date_finished | date: "%s" %}
    {% if t.date_started and t.date_finished %}
      {% assign seconds = finished_s | minus: started_s %}
      {% assign days = seconds | divided_by: 86400 %}
    {% endif %}
    <tr>
      <td><a href="{{ t.url | relative_url }}">{{ t.batch | default: t.title }}</a></td>
      <td>{{ t.date_started }}</td>
      <td>{{ t.date_finished | default: "—" }}</td>
      <td>{{ t.status | default: "—" }}</td>
      <td>
        {% if t.rocks %}{{ t.rocks | join: ", " }}{% else %}—{% endif %}
      </td>
      <td>{% if days %}{{ days }}{% else %}—{% endif %}</td>
    </tr>
  {% endfor %}
  </tbody>
</table>

## Filters

### In-Progress
<ul>
{% for t in site.tumbles %}
  {% if t.status == "In Progress" %}
    <li><a href="{{ t.url | relative_url }}">{{ t.batch | default: t.title }}</a> — started {{ t.date_started }}</li>
  {% endif %}
{% endfor %}
</ul>

### Completed
<ul>
{% for t in site.tumbles %}
  {% if t.status == "Completed" %}
    <li><a href="{{ t.url | relative_url }}">{{ t.batch | default: t.title }}</a> — finished {{ t.date_finished }}</li>
  {% endif %}
{% endfor %}
</ul>