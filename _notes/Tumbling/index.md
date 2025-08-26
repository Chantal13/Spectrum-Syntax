---
title: Tumbling Batches
permalink: /tumbling/
layout: default
---

# Tumbling Batches

```html
<p><strong>Debug:</strong> site.tumbles size = {{ site.tumbles | size }}</p>
<ul>
{% for doc in site.tumbles %}
  <li>{{ doc.relative_path }} — title: {{ doc.title | default: "(no title)" }}</li>
{% endfor %}
</ul>

```

```html
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
  {% assign items = site.tumbles | sort: "date_started" | reverse %}
  {% for t in items %}
    {% comment %}
      Safe duration math only if both dates exist
    {% endcomment %}
    {% assign days = "" %}
    {% if t.date_started and t.date_finished %}
      {% assign started_s  = t.date_started  | date: "%s" %}
      {% assign finished_s = t.date_finished | date: "%s" %}
      {% if started_s and finished_s %}
        {% assign seconds = finished_s | minus: started_s %}
        {% assign days = seconds | divided_by: 86400 %}
      {% endif %}
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
  </tbody>
</table>
</div>
```