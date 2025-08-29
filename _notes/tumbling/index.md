---
title: Tumbling Batches
permalink: /tumbling/
layout: default
---

# Tumbling Batches

{% comment %}
Collect all tumbling docs under _notes/tumbling (they are part of the
`notes` collection), exclude this index, and sort by date_started desc.
{% endcomment %}
{% assign items = site.notes | where_exp: "p", "p.path contains '_notes/tumbling/'" %}
{% assign items = items | where_exp: "p", "p.path != '_notes/tumbling/index.md'" %}
{% assign items = items | sort: "date_started" | reverse %}

<div class="tumble-index">
  <table class="nice-table">
    <thead>
      <tr>
        <th>Batch</th>
        <th>Started</th>
        <th>Finished</th>
        <th>Status</th>
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
              {% assign has_batch = d.batch and d.batch != '' %}
              {% assign has_title = d.title and d.title != '' %}
              {% if has_batch and has_title %}
                {% assign display_text = d.batch | append: " — " | append: d.title %}
              {% elsif has_batch %}
                {% assign display_text = d.batch %}
              {% elsif has_title %}
                {% assign display_text = d.title %}
              {% else %}
                {% assign display_text = "Untitled" %}
              {% endif %}
              {% if thumb %}
                <a class="thumb" href="{{ d.url | relative_url }}" aria-label="Open {{ display_text }}">
                  <img src="{{ thumb | relative_url }}" alt="{{ display_text }}" onerror="this.parentNode.classList.add('thumb--empty'); this.remove();">
                  <span class="label">{{ display_text }}</span>
                </a>
              {% else %}
                <a class="thumb thumb--empty" href="{{ d.url | relative_url }}" aria-label="Open {{ display_text }}">
                  <svg class="icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                    <rect x="2" y="4" width="20" height="16" rx="2" ry="2" fill="none" stroke="currentColor" stroke-width="1.5"/>
                    <circle cx="8" cy="10" r="2" fill="currentColor"/>
                    <path d="M5 18l5-6 4 5 3-3 3 4" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  <span class="label">{{ display_text }}</span>
                </a>
              {% endif %}
              <div class="batch-meta">
                <a href="{{ d.url | relative_url }}">
                  {% if has_batch and has_title %}<strong>{{ d.batch }}</strong> — {{ d.title }}{% elsif has_batch %}<strong>{{ d.batch }}</strong>{% elsif has_title %}<strong>{{ d.title }}</strong>{% else %}<strong>Untitled</strong>{% endif %}
                </a>
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
              {% assign raw = d.status | default: "pending" | downcase | strip %}
              {% assign st = raw %}
              {% if raw == "completed" or raw == "finished" or raw == "done" %}
                {% assign st = "tumbled" %}
              {% elsif raw == "in progress" or raw == "in-progress" or raw == "progress" or raw == "running" or raw == "active" %}
                {% assign st = "tumbling" %}
              {% elsif raw == "pending" or raw == "planned" or raw == "queued" %}
                {% assign st = "pending" %}
              {% endif %}
              <span class="status status--{{ st }}">{{ st }}</span>
            </td>
            <td>{% if days != "" %}{{ days }}{% else %}—{% endif %}</td>
          </tr>
        {% endfor %}
      {% else %}
        <tr>
          <td colspan="5">No batches found. Put markdown files in <code>_notes/tumbling/</code> with front matter.</td>
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
[class^="chip--"]{color:var(--chip-text)}
/* override any rock-specific backgrounds */

/* status pills moved to global stylesheet */
</style>
