#!/usr/bin/env python3
"""
Warn if any JPG/PNG images under assets/rocks or assets/tumbling are missing
same-name .webp siblings. Non-fatal: always exits 0.
"""
from __future__ import annotations
import os
from pathlib import Path

ROOTS = [Path('assets/rocks'), Path('assets/tumbling')]
SRC_EXT = {'.jpg', '.jpeg', '.png'}

def find_missing() -> list[Path]:
    missing: list[Path] = []
    for root in ROOTS:
        if not root.exists():
            continue
        for p, _, files in os.walk(root):
            for name in files:
                src = Path(p) / name
                if src.suffix.lower() not in SRC_EXT:
                    continue
                webp = src.with_suffix('.webp')
                if not webp.exists():
                    missing.append(src)
    return missing

def main() -> int:
    missing = find_missing()
    if not missing:
        return 0
    print(f"[pre-push:webp] {len(missing)} image(s) missing .webp sibling:")
    limit = 20
    for i, p in enumerate(missing[:limit], 1):
        print(f"  {i:2d}. {p}")
    if len(missing) > limit:
        print(f"  … and {len(missing)-limit} more")
    print("\nSuggestion: run 'bundle exec rake webp' and commit the new .webp files.")
    return 0

if __name__ == '__main__':
    raise SystemExit(main())

