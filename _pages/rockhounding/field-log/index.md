---
layout: page
title: Field Log
permalink: /rockhounding/field-log/
breadcrumbs:
  - title: Rockhounding
    url: /rockhounding/
---

<h1>Field Identification Log</h1>

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
