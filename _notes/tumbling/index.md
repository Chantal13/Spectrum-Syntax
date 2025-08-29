---
title: Tumbling Batches
permalink: /tumbling/
layout: default
---

# Tumbling Batches

{% assign coll = site.tumble_logs %}
{% if coll %}
  {% assign items = coll | sort: "date_started" | reverse %}
{% else %}
  {% assign items = "" | split: "," %}
{% endif %}

<div class="tumble-index">
  <table class="nice-table">
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
      {% if items and items.size > 0 %}
        {% for d in items %}
          {% assign thumb = nil %}
          {% assign cand = d.images.cover | image_exists %}
          {% if cand %}{% assign thumb = cand %}{% endif %}

          {% if thumb == nil %}
            {% assign cand = d.images.after_stage_5 | image_exists %}
            {% if cand %}{% assign thumb = cand %}{% endif %}
          {% endif %}
          {% if thumb == nil %}
            {% assign cand = d.images.after_stage_4 | image_exists %}
            {% if cand %}{% assign thumb = cand %}{% endif %}
          {% endif %}
          {% if thumb == nil %}
            {% assign cand = d.images.after_stage_3 | image_exists %}
            {% if cand %}{% assign thumb = cand %}{% endif %}
          {% endif %}
          {% if thumb == nil %}
            {% assign cand = d.images.after_stage_2 | image_exists %}
            {% if cand %}{% assign thumb = cand %}{% endif %}
          {% endif %}
          {% if thumb == nil %}
            {% assign cand = d.images.after_stage_1 | image_exists %}
            {% if cand %}{% assign thumb = cand %}{% endif %}
          {% endif %}
          {% if thumb == nil %}
            {% assign cand = d.images.after_burnish | image_exists %}
            {% if cand %}{% assign thumb = cand %}{% endif %}
          {% endif %}
          {% if thumb == nil %}
            {% assign cand = d.images.rough | image_exists %}
            {% if cand %}{% assign thumb = cand %}{% endif %}
          {% endif %}

          {% assign days = "" %}
          {% if d.date_started and d.date_finished %}
            {% assign started_s  = d.date_started  | date: "%s" %}
            {% assign finished_s = d.date_finished | date: "%s" %}
            {% assign seconds = finished_s | minus: started_s %}
            {% assign days = seconds | divided_by: 86400 %}
          {% endif %}

          <tr>
            <td class="batch-cell">
              {% if thumb %}
                <a class="thumb" href="{{ d.url | relative_url }}">
                  <img src="{{ thumb | relative_url }}" alt="{{ d.title | default: d.batch }}" onerror="this.parentNode.classList.add('thumb--empty'); this.remove();">
                  <span class="label">{{ d.batch | default: d.title }}</span>
                </a>
              {% else %}
                <a class="thumb thumb--empty" href="{{ d.url | relative_url }}" aria-label="Open {{ d.title | default: d.batch }}">
                  <svg class="icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                    <rect x="2" y="4" width="20" height="16" rx="2" ry="2" fill="none" stroke="currentColor" stroke-width="1.5"/>
                    <circle cx="8" cy="10" r="2" fill="currentColor"/>
                    <path d="M5 18l5-6 4 5 3-3 3 4" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  <span class="label">{{ d.batch | default: d.title }}</span>
                </a>
              {% endif %}
              <div class="batch-meta">
                <a href="{{ d.url | relative_url }}"><strong>{{ d.batch | default: d.title }}</strong></a>
                {% if d.rocks and d.rocks.size > 0 %}
                  <div class="chips">
                    {% for rock in d.rocks %}
                      {% assign rk = rock | downcase | strip | replace: " ", "-" | replace: "_", "-" | replace: "/", "-" %}
                      <span class="chip chip--{{ rk }}">{{ rock }}</span>
                    {% endfor %}
                  </div>
                {% endif %}
              </div>
            </td>
            <td>{{ d.date_started | default: "—" }}</td>
            <td>{{ d.date_finished | default: "—" }}</td>
            <td>
              {% assign st = d.status | default: "Pending" | downcase %}
              <span class="status status--{{ st | replace: ' ', '-' }}">
                {{ d.status | default: "Pending" }}
              </span>
            </td>
            <td>
              {% if d.rocks and d.rocks.size > 0 %}
                {{ d.rocks | join: ", " }}
              {% else %}—{% endif %}
            </td>
            <td>{% if days != "" %}{{ days }}{% else %}—{% endif %}</td>
          </tr>
        {% endfor %}
      {% else %}
        <tr>
          <td colspan="6">No batches found. Put markdown files in your tumbling collection with front matter.</td>
        </tr>
      {% endif %}
    </tbody>
  </table>
</div>

<style>
.tumble-index .nice-table{width:100%;border-collapse:separate;border-spacing:0;background:var(--card-a);border:1px solid var(--panel-border);border-radius:8px;overflow:hidden}
.tumble-index thead th{font-weight:600;text-align:left;padding:.6rem;border-bottom:1px solid var(--panel-border);background:var(--table-header-bg);color:var(--color-text)}
.tumble-index tbody td{border-bottom:1px solid #eee2; padding:.55rem;vertical-align:middle}
.tumble-index tbody tr:nth-child(even){background:var(--card-b)}
.batch-cell{display:flex;gap:.75rem;align-items:center}
.thumb{display:block;width:128px;min-width:128px;height:96px;border-radius:6px;overflow:hidden;border:1px solid var(--panel-border);background:var(--card-a)}
.thumb img{width:100%;height:100%;object-fit:cover;display:block}
.thumb .label{display:none}
.thumb--empty .label{display:block}
.thumb--empty{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:.25rem;background:repeating-linear-gradient(45deg,#f6f7f9,#f6f7f9 8px,#eef1f4 8px,#eef1f4 16px);color:#5b6770;border:1px solid rgba(0,0,0,.08);text-decoration:none;font-weight:600;font-size:.9rem}
.thumb--empty .icon{width:28px;height:28px;opacity:.7}
.thumb--empty .label{line-height:1}
.batch-meta{display:flex;flex-direction:column;gap:.25rem}
.chips{display:flex;gap:.25rem;flex-wrap:nowrap;overflow-x:auto;max-width:100%}
.chip{display:inline-block;padding:.1rem .45rem;border-radius:999px;font-size:.75em;border:1px solid var(--chip-border);white-space:nowrap;color:var(--chip-text);background:var(--chip-b)}
.chips .chip:nth-child(4n+1){background:var(--chip-a)}
.chips .chip:nth-child(4n+2){background:var(--chip-b)}
.chips .chip:nth-child(4n+3){background:var(--chip-c)}
.chips .chip:nth-child(4n+4){background:var(--chip-d)}
/* rock colours (same as layout, extend as needed) */
[class^="chip--"]{color:#2b2b26}
/* override any rock-specific backgrounds */

/* status pills */
.status{padding:.15rem .5rem;border-radius:999px;font-size:.8em;border:1px solid #d9d2c4;color:#333d29}
.status--pending{background:#f3eadf}
.status--in-progress{background:#e7ecdf}
.status--completed{background:#e8efe6}
</style>
