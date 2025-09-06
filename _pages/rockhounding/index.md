---
layout: page
title: Rockhounding
permalink: /rockhounding/
rocks:
  - url: '/rockhounding/rocks/'
    title: 'Rocks & Minerals'
    description: 'Igneous, metamorphic, sedimentary, and rock‑forming minerals with key tells, quick tests, photos, and Ontario context.'
  - url: '/rockhounding/guides/'
    title: 'Guides'
    description: 'Where to go, what to bring, how to look—plus safety, ethics, and beginner IDs.'
  - url: '/rockhounding/logs/'
    title: 'Logbook'
    description: 'Field log and tumbling batches together.'
  - url: '/rockhounding/resources/'
    title: 'Resources'
    description: 'Curated books, websites, articles, and social accounts; books sync from my Goodreads shelf.'
---

<h1>Rockhounding</h1>

<p>Practical, Ontario‑first field notes for finding, identifying, and polishing rocks and minerals. New to the hobby? Start with Guides. Trying to ID a find? Jump to Rocks or Minerals. Ready to polish? See Tumbling.</p>

<p><em>Regional focus: Lake Ontario’s north shore and Southern Ontario; methods apply broadly.</em></p>

<div class="rock-card-grid">
  {% for rock in page.rocks %}
    {% include rock-card.html rock=rock %}
  {% endfor %}
</div>
{% include notes_graph.html only_category='rockhounding' title='Rockhounding Notes Graph' %}
