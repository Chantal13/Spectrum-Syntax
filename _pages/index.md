---
layout: page
title: Home
id: home
permalink: /
---

# 🧿 Welcome to Spectrum Syntax!

This site is my working notebook—mostly rockhounding (Ontario-focused but useful anywhere), a bit of Python programming, and, for now, one humble blog post. I like doing lots of different things—aviation, guitar, and whatever else catches my curiosity—so expect the topics to wander as I do.

<p style="padding: 3em 1em; background: #f5f7ff; border-radius: 4px;">
  Take a look at my <span style="font-weight: bold">[[blog]]</span> while you are here, too.
</p>

Here is what I am currently interested in:

<ul>
  <li><span style="font-weight: bold">[[Python]]</span></li>
  <li><span style="font-weight: bold">[[Rockhounding]]</span></li>
</ul>

<strong>Recently updated notes</strong>

<ul>
  {% assign recent_notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in recent_notes limit: 5 %}
    <li>
      {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>

<style>
  .wrapper {
    max-width: 46em;
  }
</style>
