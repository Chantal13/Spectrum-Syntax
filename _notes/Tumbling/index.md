---
title: Tumbling Batches
permalink: /tumbling/
layout: default
---

# Tumbling Batches

Whee!

{% include tumbles-table.html %}

<p>Collections: {% for c in site.collections %}{{ c.label }} {% endfor %}</p>
<p>site.tumbles size = {{ site.tumbles | size }}</p>
<p>site.notes size = {{ site.collections["notes"] ? site.collections["notes"].docs | size : 0 }}</p>