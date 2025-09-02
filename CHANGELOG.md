# Changelog

All notable changes to this project are documented here.

## 2025-09-02

- Added: Graph displayed inside a polished card with border, radius, padding, and a compact header ("Notes Graph").
- Added: Helpful caption in Canadian English: “Tip: Hover a node to highlight its neighbours. Colours indicate categories; click a node to open its note.”
- Changed: Graph background is lighter than the page background for improved node contrast; the wrapper is transparent so the card provides the background.
- Changed: Nodes coloured by category using the provided palette (imperial red → paynes gray). Palette is exposed as CSS variables and consumed by D3.
- Changed: SVG sizing follows the card’s inner width; height targets ~80% of the viewport for comfortable viewing.
- Implementation: Generator attaches a simple `category` to each node (first folder under `_notes/`), D3 maps categories to the palette with a stable hash.
- Note: Rebuild the Jekyll site for `notes_graph.json` to include categories.

