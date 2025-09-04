---
layout: page
title: Logs
permalink: /logs/
---

<h1>Logs</h1>

<h2>Field Identification Log</h2>

<ul class="field-log-list">
{% assign items = site.notes | where_exp: "n", "n.path contains '_notes/rockhounding/field-log/'" | sort: 'date' | reverse %}
{% for item in items %}
  <li>
    <a href="{{ item.url | relative_url }}">{{ item.date | date: '%Y-%m-%d' }} – {{ item.title }}</a>
    {% if item.rocks %}
      <span class="chips">
        {% for r in item.rocks %}<span class="chip chip--{{ r | slugify }}">{{ r }}</span>{% endfor %}
      </span>
    {% endif %}
    {% if item.minerals %}
      <span class="chips">
        {% for m in item.minerals %}<span class="chip chip--{{ m | slugify }}">{{ m }}</span>{% endfor %}
      </span>
    {% endif %}
  </li>
{% endfor %}
</ul>

<h2>Tumbling Batches</h2>

{% include tumbles-table.html %}

