# kaskas — logo assets

Drop-in logo set for the kaskas project, sized for everywhere you'll need it.

## Files

| File | Use for |
|---|---|
| `mark.svg` | icon-only, brand green (default mark) |
| `mark-black.svg` · `mark-white.svg` | mono variants |
| `lockup-light.svg` | mark + wordmark, dark text on light bg |
| `lockup-dark.svg` | mark + wordmark, light text on dark bg |
| `lockup-mono-black.svg` · `lockup-mono-white.svg` | mono lockups |
| `avatar.svg` · `avatar.png` (1024) | GitHub / npm / Discord avatar |
| `favicon.svg` | scalable favicon (modern browsers) |
| `favicon-16.png` … `favicon-256.png` | raster favicons |
| `apple-touch-icon.png` (180×180) | iOS home-screen icon |
| `android-chrome-192.png` / `-512.png` | Android / PWA |
| `og-image.png` (1200×630) | social share preview (`og:image`, `twitter:image`) |
| `banner.png` (1280×320) | GitHub repo "social preview" image / docs hero |
| `site.webmanifest` | PWA manifest skeleton |

## Drop into a GitHub Pages site

In your `<head>`:

```html
<link rel="icon" type="image/svg+xml" href="/logo/favicon.svg">
<link rel="icon" type="image/png" sizes="32x32" href="/logo/favicon-32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/logo/favicon-16.png">
<link rel="apple-touch-icon" sizes="180x180" href="/logo/apple-touch-icon.png">
<link rel="manifest" href="/logo/site.webmanifest">
<meta name="theme-color" content="#0b0f12">

<!-- social previews -->
<meta property="og:image" content="https://your-domain/logo/og-image.png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="https://your-domain/logo/og-image.png">
```

## Brand colors

```css
--kaskas-green:    #22c55e;   /* primary mark color, accents, CTAs */
--kaskas-charcoal: #0b0f12;   /* default background / dark mode */
--kaskas-ink:      #e6edf3;   /* text on charcoal */
--kaskas-mute:     #8b949e;   /* secondary text on charcoal */
```

## Wordmark font

Inter, weight 700, lowercase, letter-spacing -0.045em.

```css
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
font-weight: 700;
font-size: 1em;
letter-spacing: -0.045em;
```

Load Inter via Google Fonts or self-host:

```html
<link rel="preconnect" href="https://rsms.me/">
<link rel="stylesheet" href="https://rsms.me/inter/inter.css">
```

## Clear space + don'ts

- Clear space: at least **½ × mark height** on every side.
- Minimum mark size: **16 px**.
- Don't apply gradients, drop shadows, outlines, or non-uniform scaling.
- Don't recolor the mark outside the four approved color roles (green / black / white / on-green).
