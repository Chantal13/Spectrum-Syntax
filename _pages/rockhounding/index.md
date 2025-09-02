---
layout: page
title: Rockhounding
permalink: /rockhounding/
rocks:
  - url: '/rockhounding/rocks/'
    title: 'Rocks'
    description: 'Igneous, metamorphic, and sedimentary pages with key tells, photos, and Ontario context.'
  - url: '/rockhounding/rocks/minerals/'
    title: 'Minerals'
    description: 'Rock‑forming minerals with quick tests (hardness, streak) and in‑the‑field visuals.'
  - url: '/rockhounding/guides/'
    title: 'Guides'
    description: 'Where to go, what to bring, how to look—plus safety, ethics, and beginner IDs.'
  - url: '/tumbling/'
    title: 'Tumbling'
    description: 'Grit/media recipes, step‑by‑step runs, and troubleshooting notes from real batches.'
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

<h2>Quick Links</h2>
<ul>
  <li><a class="internal-link" href="{{ '/rockhounding/rocks/igneous/' | relative_url }}">Igneous</a> · <a class="internal-link" href="{{ '/rockhounding/rocks/metamorphic/' | relative_url }}">Metamorphic</a> · <a class="internal-link" href="{{ '/rockhounding/rocks/sedimentary/' | relative_url }}">Sedimentary</a></li>
  <li><a class="internal-link" href="{{ '/rockhounding/resources/books/' | relative_url }}">Books</a> · <a class="internal-link" href="{{ '/rockhounding/resources/websites/' | relative_url }}">Websites</a> · <a class="internal-link" href="{{ '/rockhounding/resources/articles/' | relative_url }}">Articles</a></li>
</ul>
