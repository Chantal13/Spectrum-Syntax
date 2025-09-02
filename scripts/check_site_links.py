#!/usr/bin/env python3
"""
Scan the generated _site for broken internal links and assets.

Usage:
  python3 scripts/check_site_links.py

Exits non-zero if any missing references are found.
"""
import os
import re
import sys

ROOT = os.path.join(os.path.dirname(__file__), "..", "_site")

if not os.path.isdir(ROOT):
    print("_site not found. Build the site first: bundle exec jekyll build", file=sys.stderr)
    sys.exit(2)

missing = []
html_files = []
for base, _, files in os.walk(ROOT):
    for f in files:
        if f.endswith('.html'):
            html_files.append(os.path.join(base, f))

href_re = re.compile(r'<a\s+[^>]*href=[\"\']([^\"\'#]+)')
src_re  = re.compile(r'<img\s+[^>]*src=[\"\']([^\"\']+)')

def map_url_to_file(url: str):
    if not url.startswith('/'):
        return None
    p = url.lstrip('/')
    cand_dir = os.path.join(ROOT, p, 'index.html')
    if os.path.isfile(cand_dir):
        return cand_dir
    cand_html = os.path.join(ROOT, p + '.html')
    if os.path.isfile(cand_html):
        return cand_html
    cand_exact = os.path.join(ROOT, p)
    if os.path.isfile(cand_exact):
        return cand_exact
    return None

def map_asset(url: str):
    if url.startswith(('http://', 'https://', 'data:')):
        return True
    if url.startswith('/'):
        p = os.path.join(ROOT, url.lstrip('/'))
        return os.path.isfile(p)
    # Relative assets not validated here
    return True

for html in html_files:
    try:
        with open(html, 'r', encoding='utf-8', errors='ignore') as fh:
            s = fh.read()
    except Exception:
        continue
    for m in href_re.finditer(s):
        href = m.group(1)
        if href.startswith(('#', 'mailto:', 'javascript:', 'http://', 'https://', 'data:')):
            continue
        mapped = map_url_to_file(href)
        if not mapped:
            missing.append((html, 'href', href))
    for m in src_re.finditer(s):
        src = m.group(1)
        if src.startswith(('http://', 'https://', 'data:')):
            continue
        ok = map_asset(src)
        if not ok:
            missing.append((html, 'src', src))

if missing:
    print("Broken references found:")
    for path, kind, url in missing:
        print(f"- {kind}: {url} (on {os.path.relpath(path)})")
    sys.exit(1)
else:
    print("No missing internal links or assets found in _site")
    sys.exit(0)

