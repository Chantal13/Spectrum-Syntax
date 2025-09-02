---
layout: page
title: Rockhounding
permalink: /rockhounding/
---

<h1>Rockhounding</h1>

<p>Field-tested notes on finding, identifying, and caring for rocks and minerals—Ontario-focused, useful anywhere. Start with the guides if you’re new, or jump to rocks and minerals when you want to ID a find.</p>

<div class="rock-card-grid">
  {% include rock-card.html rock={
    url: '/rockhounding/guides/',
    title: 'Guides',
    description: 'Start here: how to scout locations, gear to bring, ethics and safety, and field ID basics.'
  } %}

  {% include rock-card.html rock={
    url: '/rockhounding/rocks/',
    title: 'Rocks',
    description: 'Browse igneous, metamorphic, and sedimentary rocks with identification cues and typical Ontario contexts.'
  } %}

  {% include rock-card.html rock={
    url: '/rockhounding/rocks/minerals/',
    title: 'Minerals',
    description: 'Common rock-forming minerals, quick tests (hardness, streak), and visual tells in the field.'
  } %}

  {% include rock-card.html rock={
    url: '/rockhounding/resources/',
    title: 'Resources',
    description: 'Books, websites, articles, and social accounts. The Books page pulls live from my Goodreads shelf.'
  } %}

  {% include rock-card.html rock={
    url: '/tumbling/',
    title: 'Tumbling',
    description: 'Step-by-step processes, media recipes, and troubleshooting logs for rock tumbling.'
  } %}
</div>

<h2>Quick Links</h2>
<ul>
  <li><a class="internal-link" href="{{ '/rockhounding/rocks/igneous/' | relative_url }}">Igneous</a> · <a class="internal-link" href="{{ '/rockhounding/rocks/metamorphic/' | relative_url }}">Metamorphic</a> · <a class="internal-link" href="{{ '/rockhounding/rocks/sedimentary/' | relative_url }}">Sedimentary</a></li>
  <li><a class="internal-link" href="{{ '/rockhounding/resources/books/' | relative_url }}">Books</a> · <a class="internal-link" href="{{ '/rockhounding/resources/websites/' | relative_url }}">Websites</a> · <a class="internal-link" href="{{ '/rockhounding/resources/articles/' | relative_url }}">Articles</a></li>
</ul>
