#!/usr/bin/env python3
import os, re, sys, pathlib

# Simple Canadian English linter for site content files.
# Scans .md and .html under content paths and flags US spellings.

ROOT = pathlib.Path(__file__).resolve().parents[1]

def default_content_dirs():
    dirs = [
        ROOT / "_pages",
        ROOT / "_includes",
        ROOT / "_layouts",
        ROOT / "_admin",
    ]
    # Opt-in to scan notes by setting SCAN_NOTES=1
    if os.environ.get("SCAN_NOTES") == "1":
        dirs.append(ROOT / "_notes")
    return dirs

ALLOWED_EXT = {".md", ".markdown", ".html"}

# Word-level patterns: (regex, suggestion)
RULES = [
    (r"\bluster\b", "lustre"),
    (r"\bcolorless\b", "colourless"),
    (r"\bfavorite\b", "favourite"),
    (r"\bfavorites\b", "favourites"),
    (r"\bgray\b", "grey"),
    (r"\bcenter\b", "centre"),
    (r"\bcentered\b", "centred"),
    (r"\bcentering\b", "centring"),
    (r"\bmeters\b", "metres"),
    (r"\bmeter\b", "metre"),
    (r"\bliters\b", "litres"),
    (r"\bliter\b", "litre"),
    (r"\bfibers\b", "fibres"),
    (r"\bfiber\b", "fibre"),
    (r"\banalysis\b", "analysis"),  # allow, but below catches analyze variants
    (r"\banalyses\b", "analyses"),  # allow
    (r"\banalyzes\b", "analyses"),
    (r"\banalyzed\b", "analysed"),
    (r"\banalyzing\b", "analysing"),
    (r"\banalyze\b", "analyse"),
    (r"\bdefense\b", "defence"),
    (r"\boffense\b", "offence"),
    (r"\bcatalogs\b", "catalogues"),
    (r"\bcatalog\b", "catalogue"),
]

# Files/globs to skip entirely
SKIP_PATH_SUBSTR = [
    "_site/",
    "vendor/",
    ".github/",
    "assets/",
    "netlify/",
]

# Per-line skip marker
SKIP_MARKER = "ca-spell: ignore-line"

def is_skipped_path(p: pathlib.Path) -> bool:
    s = str(p)
    for sub in SKIP_PATH_SUBSTR:
        if sub in s:
            return True
    return False

def should_scan_file(p: pathlib.Path) -> bool:
    return (p.suffix.lower() in ALLOWED_EXT) and not is_skipped_path(p)

def strip_code_regions(text: str) -> str:
    # Remove fenced code blocks in Markdown
    lines = text.splitlines()
    out = []
    in_fence = False
    for ln in lines:
        if ln.strip().startswith("```"):
            in_fence = not in_fence
            out.append("")
            continue
        if in_fence:
            out.append("")
            continue
        out.append(ln)
    text = "\n".join(out)
    # Remove inline code `...`
    text = re.sub(r"`[^`]*`", "", text)
    # Remove <code>, <pre>, <script>, <style> contents (naive)
    text = re.sub(r"<code[\s\S]*?</code>", "", text, flags=re.IGNORECASE)
    text = re.sub(r"<pre[\s\S]*?</pre>", "", text, flags=re.IGNORECASE)
    text = re.sub(r"<script[\s\S]*?</script>", "", text, flags=re.IGNORECASE)
    text = re.sub(r"<style[\s\S]*?</style>", "", text, flags=re.IGNORECASE)
    return text

def load_allowlist() -> set:
    path = ROOT / ".canadian-spelling-allowlist.txt"
    if not path.exists():
        return set()
    words = set()
    for ln in path.read_text(encoding="utf-8").splitlines():
        ln = ln.strip()
        if not ln or ln.startswith("#"):
            continue
        words.add(ln.lower())
    return words

def main() -> int:
    allow = load_allowlist()
    issues = []
    content_dirs = default_content_dirs()
    # If explicit files provided as args, only scan those
    files = [pathlib.Path(p) for p in sys.argv[1:]] if len(sys.argv) > 1 else None
    if files:
        targets = files
    else:
        targets = []
        for base in content_dirs:
            if not base.exists():
                continue
            targets.extend(base.rglob("*"))
    for p in targets:
        if not p.is_file():
            continue
        if not should_scan_file(p):
            continue
        try:
            raw = p.read_text(encoding="utf-8")
        except Exception:
            continue
            text = strip_code_regions(raw)
            for i, ln in enumerate(text.splitlines(), start=1):
                if SKIP_MARKER in ln:
                    continue
                low = ln.lower()
                for pat, sug in RULES:
                    # Skip if suggestion itself is on the line
                    if sug.lower() in low:
                        continue
                    m = re.search(pat, low)
                    if m:
                        found = m.group(0)
                        if found.lower() in allow:
                            continue
                        issues.append((p, i, found, sug))
    if issues:
        print("Canadian English linter found potential US spellings:\n")
        for p, i, found, sug in issues:
            print(f"{p}:{i}: '{found}' → '{sug}'")
        print("\nAdd per-line 'ca-spell: ignore-line' to skip, or add a word to .canadian-spelling-allowlist.txt if intentional.")
        return 1
    else:
        print("Canadian English linter: no issues found.")
        return 0

if __name__ == "__main__":
    sys.exit(main())
