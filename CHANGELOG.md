# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and the project attempts to adhere to Semantic Versioning.

## [Unreleased]

### Changed
- Remove global `overflow-x: hidden` from body to allow horizontal scrolling for wide content.

## [0.2.0] - 2025-09-02

### Added
- Graph displayed inside a polished card with border, radius, padding, and a compact header ("Notes Graph").
- Helpful caption (Canadian English): “Tip: Hover a node to highlight its neighbours. Colours indicate categories; click a node to open its note.”
- Generator attaches a simple `category` to each node (first folder under `_notes/`).

### Changed
- Graph background is lighter than the page background for improved node contrast; wrapper is transparent so the card provides the background.
- Nodes coloured by category using the provided palette (imperial red → paynes gray), exposed as CSS variables and consumed by D3.
- SVG sizing follows the card’s inner width; height targets ~80% of the viewport for comfortable viewing.

### Notes
- Rebuild the Jekyll site for `notes_graph.json` to include categories.

<!-- Links -->
[Unreleased]: https://github.com/Chantal13/Spectrum-Syntax/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/Chantal13/Spectrum-Syntax/releases/tag/v0.2.0
