---
layout: page
title: Test Page
summary: Design sandbox for layout and style experiments.
permalink: /test/
---
<style>
  @import url("https://fonts.googleapis.com/css2?family=Fraunces:wght@300;500;700&family=IBM+Plex+Sans:wght@300;400;600&display=swap");

  :root {
    --platinum: #eef0f2ff;
    --silver: #c6c7c4ff;
    --lilac-ash: #a2999eff;
    --smoky-rose: #846a6aff;
    --gunmetal: #353b3cff;
    --shadow: rgba(53, 59, 60, 0.25);
  }

  .test-page {
    font-family: "IBM Plex Sans", sans-serif;
    color: var(--gunmetal);
    padding: 2.5rem 1.5rem 4rem;
    background:
      radial-gradient(circle at 12% 18%, rgba(162, 153, 158, 0.4), transparent 48%),
      radial-gradient(circle at 88% 20%, rgba(198, 199, 196, 0.55), transparent 40%),
      linear-gradient(135deg, var(--platinum), var(--silver) 35%, var(--lilac-ash) 65%, var(--smoky-rose) 100%);
    border-radius: 28px;
    position: relative;
    overflow: hidden;
  }

  .test-page::after {
    content: "";
    position: absolute;
    inset: -40% -25% auto auto;
    width: 320px;
    height: 320px;
    background: linear-gradient(130deg, rgba(132, 106, 106, 0.6), rgba(53, 59, 60, 0.2));
    border-radius: 50%;
    filter: blur(0);
    opacity: 0.7;
    pointer-events: none;
  }

  .test-hero {
    max-width: 960px;
    margin: 0 auto 2.5rem;
    position: relative;
  }

  .test-kicker {
    text-transform: uppercase;
    letter-spacing: 0.25em;
    font-size: 0.78rem;
    color: var(--smoky-rose);
    margin-bottom: 0.75rem;
  }

  .test-title {
    font-family: "Fraunces", serif;
    font-size: clamp(2.5rem, 5vw, 4rem);
    margin: 0 0 1rem;
  }

  .test-lede {
    font-size: 1.05rem;
    max-width: 620px;
    line-height: 1.6;
    margin-bottom: 1.5rem;
  }

  .test-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
  }

  .test-button {
    padding: 0.75rem 1.35rem;
    border-radius: 999px;
    border: 1px solid var(--gunmetal);
    text-decoration: none;
    color: var(--gunmetal);
    font-weight: 600;
    background: var(--platinum);
    box-shadow: 0 10px 20px var(--shadow);
    transition: transform 0.25s ease, box-shadow 0.25s ease;
  }

  .test-button.primary {
    background: var(--gunmetal);
    color: var(--platinum);
  }

  .test-button:hover {
    transform: translateY(-2px);
    box-shadow: 0 16px 30px rgba(53, 59, 60, 0.35);
  }

  .test-grid {
    display: grid;
    gap: 1.5rem;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    max-width: 1100px;
    margin: 0 auto 2.5rem;
  }

  .test-card {
    background: rgba(238, 240, 242, 0.82);
    border: 1px solid rgba(53, 59, 60, 0.2);
    border-radius: 20px;
    padding: 1.5rem;
    box-shadow: 0 12px 24px rgba(53, 59, 60, 0.18);
    backdrop-filter: blur(6px);
  }

  .test-card h3 {
    font-family: "Fraunces", serif;
    margin-top: 0;
    margin-bottom: 0.5rem;
  }

  .test-card p {
    margin: 0 0 1rem;
    line-height: 1.55;
  }

  .test-pill {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.35rem 0.75rem;
    border-radius: 999px;
    background: var(--lilac-ash);
    color: var(--platinum);
    font-size: 0.85rem;
    font-weight: 600;
  }

  .test-swatches {
    display: grid;
    gap: 1rem;
    grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  }

  .test-swatch {
    border-radius: 16px;
    padding: 1rem;
    color: var(--platinum);
    min-height: 110px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    box-shadow: 0 12px 20px rgba(53, 59, 60, 0.2);
  }

  .test-swatch span {
    font-weight: 600;
  }

  .test-swatch code {
    font-family: "IBM Plex Sans", sans-serif;
    font-size: 0.85rem;
  }

  .test-layout {
    max-width: 1100px;
    margin: 0 auto;
    display: grid;
    gap: 1.5rem;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  }

  .test-panel {
    background: var(--platinum);
    border-radius: 18px;
    padding: 1.25rem 1.5rem;
    border: 1px solid rgba(53, 59, 60, 0.15);
  }

  .test-panel h4 {
    margin-top: 0;
    margin-bottom: 0.75rem;
    font-family: "Fraunces", serif;
  }

  .test-panel ul {
    margin: 0;
    padding-left: 1.1rem;
  }

  .test-panel li {
    margin-bottom: 0.5rem;
  }

  .test-timeline {
    display: grid;
    gap: 0.75rem;
  }

  .test-timeline-item {
    padding: 0.75rem 1rem;
    border-left: 4px solid var(--smoky-rose);
    background: rgba(198, 199, 196, 0.45);
    border-radius: 8px;
  }

  .test-timeline-item strong {
    display: block;
    margin-bottom: 0.35rem;
  }

  .test-hero,
  .test-grid,
  .test-layout {
    animation: rise 0.7s ease both;
  }

  .test-grid {
    animation-delay: 0.2s;
  }

  .test-layout {
    animation-delay: 0.35s;
  }

  @keyframes rise {
    from {
      opacity: 0;
      transform: translateY(18px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  @media (max-width: 720px) {
    .test-page {
      padding: 2rem 1.2rem 3rem;
    }

    .test-actions {
      flex-direction: column;
      align-items: flex-start;
    }
  }

  @media (prefers-reduced-motion: reduce) {
    .test-hero,
    .test-grid,
    .test-layout {
      animation: none;
    }

    .test-button {
      transition: none;
    }
  }
</style>

<div class="test-page">
  <section class="test-hero">
    <div class="test-kicker">Spectrum Syntax Lab</div>
    <h1 class="test-title">Test page for a quiet, mineral-inspired palette.</h1>
    <p class="test-lede">
      This layout is a living style study. The palette balances cool stone
      neutrals with a dusty rose accent, and the UI leans into soft contours
      and layered textures.
    </p>
    <div class="test-actions">
      <a class="test-button primary" href="/logs/">View logs</a>
      <a class="test-button" href="/rockhounding/">Explore rockhounding</a>
    </div>
  </section>

  <section class="test-grid">
    <article class="test-card">
      <span class="test-pill">Feature</span>
      <h3>Sectioned layout</h3>
      <p>Cards, panels, and timeline blocks help organize information without heavy dividers.</p>
      <a class="test-button" href="/games/">Browse games</a>
    </article>
    <article class="test-card">
      <span class="test-pill">Tone</span>
      <h3>Muted contrast</h3>
      <p>The gunmetal anchor keeps typography crisp while the rest stays soft and atmospheric.</p>
      <a class="test-button" href="/about/">About the site</a>
    </article>
    <article class="test-card">
      <span class="test-pill">Materials</span>
      <h3>Swatch overview</h3>
      <p>Each color appears with its hex code to make future implementation quick.</p>
      <div class="test-swatches">
        <div class="test-swatch" style="background: var(--platinum); color: var(--gunmetal);">
          <span>Platinum</span>
          <code>#eef0f2</code>
        </div>
        <div class="test-swatch" style="background: var(--silver); color: var(--gunmetal);">
          <span>Silver</span>
          <code>#c6c7c4</code>
        </div>
        <div class="test-swatch" style="background: var(--lilac-ash);">
          <span>Lilac Ash</span>
          <code>#a2999e</code>
        </div>
        <div class="test-swatch" style="background: var(--smoky-rose);">
          <span>Smoky Rose</span>
          <code>#846a6a</code>
        </div>
        <div class="test-swatch" style="background: var(--gunmetal);">
          <span>Gunmetal</span>
          <code>#353b3c</code>
        </div>
      </div>
    </article>
  </section>

  <section class="test-layout">
    <div class="test-panel">
      <h4>Layout notes</h4>
      <ul>
        <li>Soft gradient wash keeps the palette cohesive.</li>
        <li>Rounded containers echo tumbled stones.</li>
        <li>Buttons stay bold but calm.</li>
      </ul>
    </div>
    <div class="test-panel">
      <h4>Signals</h4>
      <div class="test-timeline">
        <div class="test-timeline-item">
          <strong>Step 01</strong>
          Palette locked, typography set, and contrast checked.
        </div>
        <div class="test-timeline-item">
          <strong>Step 02</strong>
          Cards layered with subtle blur for depth.
        </div>
        <div class="test-timeline-item">
          <strong>Step 03</strong>
          Motion tuned for a gentle lift on load.
        </div>
      </div>
    </div>
    <div class="test-panel">
      <h4>CTA slot</h4>
      <p>Use this area to announce a future feature or call for new notes.</p>
      <a class="test-button primary" href="/rockhounding/field-log/">Open field log</a>
    </div>
  </section>
</div>
