#!/usr/bin/env python3
"""
Generate .webp variants for local images under assets/rocks/ and assets/tumbling/.
Intelligent caching: only processes changed/new images based on size + mtime.
Non-fatal if Pillow missing.
"""

import hashlib
import json
import os
import sys
from pathlib import Path
from typing import Dict, Tuple

try:
    from PIL import Image, ImageOps  # type: ignore
except Exception as e:  # pragma: no cover
    print("[webp] Pillow not available; skipping.")
    sys.exit(0)

ROOTS = [Path('assets/rocks'), Path('assets/tumbling')]
IN_EXT = {'.jpg', '.jpeg', '.png'}
CACHE_FILE = Path('.webp-cache.json')

def load_cache() -> Dict[str, Tuple[float, int]]:
    """Load cache file with {path: (mtime, size)} entries."""
    if not CACHE_FILE.exists():
        return {}
    try:
        with open(CACHE_FILE, 'r') as f:
            data = json.load(f)
            # Convert to tuple format
            return {k: tuple(v) for k, v in data.items()}
    except Exception as e:
        print(f"[webp] Warning: Could not load cache ({e}), rebuilding...")
        return {}

def save_cache(cache: Dict[str, Tuple[float, int]]) -> None:
    """Save cache file."""
    try:
        with open(CACHE_FILE, 'w') as f:
            # Convert tuples to lists for JSON serialization
            json.dump({k: list(v) for k, v in cache.items()}, f, indent=2)
    except Exception as e:
        print(f"[webp] Warning: Could not save cache ({e})")

def get_file_signature(path: Path) -> Tuple[float, int]:
    """Get file signature (mtime, size) for cache comparison."""
    try:
        stat = path.stat()
        return (stat.st_mtime, stat.st_size)
    except OSError:
        return (0.0, 0)

def needs_build(src: Path, dst: Path, cache: Dict[str, Tuple[float, int]]) -> bool:
    """Check if source needs to be converted based on cache and dst existence."""
    # Always build if output doesn't exist
    if not dst.exists():
        return True

    # Check cache
    src_key = str(src)
    current_sig = get_file_signature(src)

    # If in cache and signature matches, skip
    if src_key in cache:
        cached_sig = cache[src_key]
        if current_sig == cached_sig:
            return False

    # Otherwise, need to build (new file or changed)
    return True

def convert(src: Path, dst: Path) -> bool:
    """Convert image to WebP format."""
    try:
        img = Image.open(src)
        img = ImageOps.exif_transpose(img)
        dst.parent.mkdir(parents=True, exist_ok=True)
        img.save(dst, format='WEBP', quality=78, method=6)
        return True
    except Exception as e:
        print(f"[webp] ERROR {src} -> {dst}: {e}")
        return False

def format_progress(current: int, total: int, width: int = 30) -> str:
    """Format a simple progress indicator."""
    if total == 0:
        return ""
    pct = current / total
    filled = int(width * pct)
    bar = '=' * filled + '-' * (width - filled)
    return f"[{bar}] {current}/{total}"

def main() -> int:
    """Main conversion routine with intelligent caching."""
    # Load cache
    cache = load_cache()

    # Collect all images to process
    to_process = []
    for root in ROOTS:
        if not root.exists():
            continue
        for path, _, files in os.walk(root):
            for name in files:
                p = Path(path) / name
                if p.suffix.lower() not in IN_EXT:
                    continue
                dst = p.with_suffix('.webp')
                if needs_build(p, dst, cache):
                    to_process.append(p)

    total = sum(1 for root in ROOTS if root.exists()
                for path, _, files in os.walk(root)
                for name in files
                if (Path(path) / name).suffix.lower() in IN_EXT)

    # Show initial status
    if not to_process:
        print(f"[webp] All {total} images up-to-date (cache hit)")
        return 0

    print(f"[webp] Processing {len(to_process)}/{total} images...")

    # Process images
    done = 0
    failed = 0
    for i, src in enumerate(to_process, 1):
        dst = src.with_suffix('.webp')

        # Show progress for every 10th image or last image
        if i % 10 == 0 or i == len(to_process):
            progress = format_progress(i, len(to_process))
            print(f"[webp] {progress}", end='\r')

        if convert(src, dst):
            # Update cache on success
            cache[str(src)] = get_file_signature(src)
            done += 1
        else:
            failed += 1

    # Clear progress line and show final stats
    print(' ' * 80, end='\r')  # Clear progress line
    print(f"[webp] ✓ {done} generated, {total - len(to_process)} cached, {failed} failed")

    # Save cache
    save_cache(cache)

    return 0

if __name__ == '__main__':
    raise SystemExit(main())
