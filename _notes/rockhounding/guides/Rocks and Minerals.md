---
title: Rocks and Minerals
layout: note
---
<div class="rock-card-grid">
{% assign rocks = site.notes | where_exp: "p", "p.path contains '_notes/rockhounding/rocks/'" | sort: 'title' %}
{% for rock in rocks %}
  {% unless rock.path contains '/category/' or rock.path contains '/categories/' %}
    {% include rock-card.html rock=rock %}
  {% endunless %}
{% endfor %}
</div>
