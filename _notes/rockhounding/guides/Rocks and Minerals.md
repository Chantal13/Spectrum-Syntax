---
title: Rocks and Minerals
layout: note
---
<div class="rm-index">
## A
- [[agate]]

## B
- [[breccia]]

## C
- [[calcite]]
- [[conglomerate]]

## E
- [[epidote]]

## F
- [[feldspar]]
- [[fluorite]]

## G
- [[garnet]]
- [[gneiss]]

## J
- [[jasper]]

## L
- [[limestone]]

## P
- [[pyrite]]

## Q
- [[quartz]]

## U
- [[unakite]]
</div>

<style>
/* Rocks & Minerals index: chip styling using provided palette */
.rm-index h2 + ul {
  display: flex;
  flex-wrap: wrap;
  gap: .35rem;
  list-style: none;
  padding-left: 0;
  margin: .25rem 0 1rem;
}
.rm-index h2 + ul > li { margin: 0; }
.rm-index h2 + ul > li > a {
  display: inline-block;
  padding: .15rem .5rem;
  border-radius: 9999px;
  font-size: .85em;
  line-height: 1;
  text-decoration: none;
  border: 1px solid #e6e6e6;
  color: #1f2937; /* default dark text for light chips */
}

/* Palette cycle: Melon, Eggshell, Celeste, Light blue, Payne's gray */
.rm-index h2 + ul > li:nth-child(5n+1) > a { background: #ffa69e; border-color: #ffb8b1; }
.rm-index h2 + ul > li:nth-child(5n+2) > a { background: #faf3dd; border-color: #fbf5e3; }
.rm-index h2 + ul > li:nth-child(5n+3) > a { background: #b8f2e6; border-color: #c8f5ec; }
.rm-index h2 + ul > li:nth-child(5n+4) > a { background: #aed9e0; border-color: #bee1e6; }
.rm-index h2 + ul > li:nth-child(5n+5) > a { background: #5e6472; border-color: #5e6472; color: #ffffff; }

/* Hover: slight lift and darker border for feedback */
.rm-index h2 + ul > li > a:hover {
  filter: brightness(0.98);
  border-color: rgba(0,0,0,.15);
}
</style>
