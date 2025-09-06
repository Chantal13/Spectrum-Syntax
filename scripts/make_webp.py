#!/usr/bin/env python3
"""
Generate .webp variants for local images under assets/rocks/ and assets/tumbling/.
Safe to run multiple times; skips up-to-date outputs. Non-fatal if Pillow missing.
"""

import os
import sys
from pathlib import Path

try:
    from PIL import Image, ImageOps  # type: ignore
except Exception as e:  # pragma: no cover
    print("[webp] Pillow not available; skipping.")
    sys.exit(0)

ROOTS = [Path('assets/rocks'), Path('assets/tumbling')]
IN_EXT = {'.jpg', '.jpeg', '.png'}

def needs_build(src: Path, dst: Path) -> bool:
    if not dst.exists():
        return True
    try:
        return src.stat().st_mtime > dst.stat().st_mtime
    except OSError:
        return True

def convert(src: Path, dst: Path) -> bool:
    try:
        img = Image.open(src)
        img = ImageOps.exif_transpose(img)
        dst.parent.mkdir(parents=True, exist_ok=True)
        img.save(dst, format='WEBP', quality=78, method=6)
        return True
    except Exception as e:
        print(f"[webp] ERROR {src} -> {dst}: {e}")
        return False

def main() -> int:
    total = 0
    done = 0
    for root in ROOTS:
        if not root.exists():
            continue
        for path, _, files in os.walk(root):
            for name in files:
                p = Path(path) / name
                if p.suffix.lower() not in IN_EXT:
                    continue
                dst = p.with_suffix('.webp')
                total += 1
                if needs_build(p, dst):
                    ok = convert(p, dst)
                    if ok:
                        done += 1
    print(f"[webp] {done} generated, {total - done} skipped (up-to-date)")
    return 0

if __name__ == '__main__':
    raise SystemExit(main())

