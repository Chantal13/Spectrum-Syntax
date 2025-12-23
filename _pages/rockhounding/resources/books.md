---
layout: page
title: Books
summary: Book list pulled from the Goodreads geology shelf.
permalink: /rockhounding/resources/books/
---
<h1>Books</h1>

<p>Live list pulled from my Goodreads <em>geology</em> shelf.</p>

{% assign books = site.data.goodreads.geology %}

{% if books and books.size > 0 %}
  <div class="book-card-grid">
    {% for book in books %}
      {% include book-card.html book=book %}
    {% endfor %}
  </div>
{% else %}
  <p><em>No books found yet.</em> If you’re seeing this during a fresh build, the Goodreads feed may not have loaded or the shelf is empty.</p>
{% endif %}
