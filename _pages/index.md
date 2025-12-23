---
layout: page
title: Home
summary: Homepage overview of rockhounding notes, game research, blog updates, and recent activity.
id: home
permalink: /
---
{%- assign autism_notes = site.notes | where_exp: "n", "n.path contains '_notes/notes/autism/'" -%}
{%- assign autism_notes = autism_notes | sort: "title" -%}
{%- assign random_notes = site.notes | where_exp: "n", "n.path contains '_notes/notes/random/'" -%}
{%- assign random_notes = random_notes | sort: "title" -%}
{%- assign recent_notes = site.notes | sort: "date" | reverse -%}
{%- assign blog_posts = site.notes | where_exp: "n", "n.path contains '_notes/blog/' and n.layout == 'blog'" -%}
{%- assign blog_posts = blog_posts | sort: "date" | reverse -%}
{%- assign week_ago = site.time | date: "%s" | plus: 0 | minus: 604800 -%}
{%- assign recent_updates_count = 0 -%}
{%- for n in site.notes -%}
  {%- assign n_time = n.date -%}
  {%- if n_time -%}
    {%- assign n_ts = n_time | date: "%s" | plus: 0 -%}
    {%- if n_ts > week_ago -%}
      {%- assign recent_updates_count = recent_updates_count | plus: 1 -%}
    {%- endif -%}
  {%- endif -%}
{%- endfor -%}
{%- for p in site.pages -%}
  {%- if p.path contains '_pages/' -%}
    {%- assign p_time = p.date -%}
    {%- if p_time -%}
      {%- assign p_ts = p_time | date: "%s" | plus: 0 -%}
      {%- if p_ts > week_ago -%}
        {%- assign recent_updates_count = recent_updates_count | plus: 1 -%}
      {%- endif -%}
    {%- endif -%}
  {%- endif -%}
{%- endfor -%}

<section class="welcome-hero">
  <div class="welcome-kicker">Spectrum Syntax</div>
  <h1 class="welcome-title">Welcome to Spectrum Syntax.</h1>
  <p class="welcome-lede">
    This is my working notebook: rockhounding field notes, games research, and
    the occasional side quest. It is a place to track what I am learning and
    make it useful for the next curious person who drops by.
  </p>
</section>

<section class="welcome-grid">
  <article class="welcome-card welcome-card--link welcome-blog" data-card-link="{{ '/blog/' | relative_url }}" role="link" tabindex="0" aria-label="Open the Blog index">
    <span class="welcome-pill">Blog</span>
    <h3>Inside My Mind</h3>
    <p>Short essays and observations from the notebook.</p>
    <ul class="welcome-list">
      {% for post in blog_posts limit: 3 %}
      <li>
        {{ post.date | date: "%Y-%m-%d" }}
        <a class="internal-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
        {% if post.excerpt %}
        <div class="welcome-excerpt">{{ post.excerpt | strip_html | strip_newlines | truncatewords: 18 }}</div>
        {% endif %}
      </li>
      {% endfor %}
    </ul>
  </article>
  <article class="welcome-card welcome-card--link" data-card-link="{{ '/games/' | relative_url }}" role="link" tabindex="0" aria-label="Open the Games index">
    <span class="welcome-pill">Games</span>
    <h3>Games</h3>
    <p>Strategy notes, guides, and good-to-know shortcuts.</p>
    <ul class="welcome-list">
      <li><a class="internal-link" href="{{ '/games/fortnite/' | relative_url }}">Fortnite</a></li>
      <li><a class="internal-link" href="{{ '/games/fortnite/lego-fortnite/' | relative_url }}">LEGO Fortnite</a></li>
      <li><a class="internal-link" href="{{ '/games/fallout-76/' | relative_url }}">Fallout 76</a></li>
    </ul>
  </article>
  <article class="welcome-card welcome-card--link" data-card-link="{{ '/notes/autism/Autism/' | relative_url }}" role="link" tabindex="0" aria-label="Open the Autism notes index">
    <span class="welcome-pill">Notes</span>
    <h3>Autism</h3>
    <p>Neurodivergence notes, practical language, and lived experience threads.</p>
    <ul class="welcome-list">
      {% for note in autism_notes limit: 3 %}
      <li><a class="internal-link" href="{{ note.url | relative_url }}">{{ note.title }}</a></li>
      {% endfor %}
    </ul>
  </article>
  <article class="welcome-card welcome-card--link" data-card-link="{{ '/notes/random/Random/' | relative_url }}" role="link" tabindex="0" aria-label="Open the Random notes index">
    <span class="welcome-pill">Notes</span>
    <h3>Random</h3>
    <p>Miscellaneous notes that do not fit anywhere else yet.</p>
    <ul class="welcome-list">
      {% for note in random_notes limit: 3 %}
      <li><a class="internal-link" href="{{ note.url | relative_url }}">{{ note.title }}</a></li>
      {% endfor %}
    </ul>
  </article>
  <article class="welcome-card welcome-card--link" data-card-link="{{ '/rockhounding/' | relative_url }}" role="link" tabindex="0" aria-label="Open the Rockhounding index">
    <span class="welcome-pill">Notes</span>
    <h3>Rockhounding</h3>
    <p>Ontario-focused field notes, IDs, and tumbling experiments.</p>
    <ul class="welcome-list">
      <li><a class="internal-link" href="{{ '/notes/rockhounding/guides/Rockhounding%20101/' | relative_url }}">Rockhounding 101</a></li>
      <li><a class="internal-link" href="{{ '/notes/rockhounding/guides/Rocks%20and%20Minerals/' | relative_url }}">Rocks and Minerals</a></li>
      <li><a class="internal-link" href="{{ '/notes/rockhounding/guides/Rock%20Tumbling/' | relative_url }}">Rock Tumbling</a></li>
    </ul>
  </article>
</section>

<section class="welcome-grid">
  <div class="welcome-graph">
    {% include notes_graph.html title='Graph' %}
  </div>
  <article class="welcome-card welcome-recent">
    <span class="welcome-pill">Updated</span>
    <h3>Recently updated notes</h3>
    <ul class="welcome-list">
      {% for note in recent_notes limit: 5 %}
      <li>
        {{ note.date | date: "%Y-%m-%d" }}
        <a class="internal-link" href="{{ note.url | relative_url }}">{{ note.title }}</a>
      </li>
      {% endfor %}
    </ul>
  </article>
</section>

<section class="welcome-stats">
  <div class="welcome-stat">
    <strong>{{ site.notes | size }}</strong>
    Total notes tracked.
  </div>
  <div class="welcome-stat">
    <strong>{{ recent_updates_count }}</strong>
    Notes or pages updated in the last 7 days.
  </div>
</section>

<script>
  document.querySelectorAll('.welcome-card--link[data-card-link]').forEach((card) => {
    const target = card.dataset.cardLink;
    if (!target) return;
    card.addEventListener('click', (event) => {
      if (event.target.closest('a')) return;
      window.location = target;
    });
    card.addEventListener('keydown', (event) => {
      if (event.target.closest('a')) return;
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        window.location = target;
      }
    });
  });
</script>
