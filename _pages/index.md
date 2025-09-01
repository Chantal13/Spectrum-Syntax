---
layout: page
title: Home
id: home
permalink: /
---

# 🧿 Welcome to Spectrum Syntax!

This site is my working notebook—mostly rockhounding (Ontario-focused but useful anywhere), a bit of Python programming, and, for now, one humble blog post. I like doing lots of different things—aviation, guitar, and whatever else catches my curiosity—so expect the topics to wander as I do.

Take a look at my blog <span style="font-weight: bold">[[Inside My Mind]]</span> while you are here.

Here is what I am currently interested in:
  <ul>
    <li><span style="font-weight: bold">[[Python]]</span></li>
    <li><span style="font-weight: bold">[[rockhounding]]</span></li>
  </ul>
I also play games like these:
  <ul>
    <li><span style="font-weight: bold">[[IDLE Champions]]</span></li>
    <li><span style="font-weight: bold">[[Dark War Survival]]</span></li>
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
