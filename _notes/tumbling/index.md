---
title: Tumbling Batches
permalink: /tumbling/
layout: default
---

# Tumbling Batches

Whee!

<p>Collections: {% for c in site.collections %}{{ c.label }} {% endfor %}</p>
<p>tumbles exists? {% if site.collections.tumbles %}yes{% else %}no{% endif %}</p>
<p>tumbles size: {% if site.collections.tumbles %}{{ site.collections.tumbles.docs | size }}{% else %}0{% endif %}</p>
<ul>
{% if site.collections.tumbles %}
  {% for d in site.collections.tumbles.docs %}
    <li>{{ d.relative_path }} — {{ d.title }}</li>
  {% endfor %}
{% endif %}
</ul>

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
    <tr><td colspan="6">No batches found. Put markdown files in <code>_tumbles/</code> with frontmatter.</td></tr>
  {% endif %}
  </tbody>
</table>
</div>
