/* ────────────────────────────────────────────────────────────────
   kaskas — logo mark studies
   All marks are drawn on a 64×64 grid, single-color, geometric.
   Each accepts { size, color, accent } so we can recolor per surface.
   ──────────────────────────────────────────────────────────────── */

const GREEN = "#22c55e";

/* A — Swipe K
   The bold geometric K *is* the mark. The vertical stem is a
   rounded pill, like a credit card seen edge-on; the two arms
   spring out of its middle as if mid-swipe. Reads as: K, card, motion. */
function MarkSwipeK({ size = 64, color = GREEN, style }) {
  return (
    <svg viewBox="0 0 64 64" width={size} height={size} style={style} aria-hidden="true">
      <rect x="12" y="11" width="9" height="42" rx="4.5" fill={color} />
      <path d="M21 32 L50 11"
        stroke={color} strokeWidth="9" strokeLinecap="round" fill="none" />
      <path d="M21 32 L50 53"
        stroke={color} strokeWidth="9" strokeLinecap="round" fill="none" />
    </svg>
  );
}

/* B — Swipe chevron
   Two stacked chevrons. The trailing one is thinner, suggesting
   swipe-trail/motion. Also reads as `>>` — CLI prompt. */
function MarkChevron({ size = 64, color = GREEN, style }) {
  return (
    <svg viewBox="0 0 64 64" width={size} height={size} style={style} aria-hidden="true">
      <path d="M16 16 L28 32 L16 48"
        stroke={color} strokeWidth="5" strokeLinecap="round" strokeLinejoin="round"
        fill="none" opacity="0.4" />
      <path d="M30 16 L46 32 L30 48"
        stroke={color} strokeWidth="9" strokeLinecap="round" strokeLinejoin="round"
        fill="none" />
    </svg>
  );
}

/* C — Stacked cards
   Three offset rounded cards. Reads as: fanned deck mid-swipe,
   memory layers, a stack of transactions remembered. */
function MarkStack({ size = 64, color = GREEN, style }) {
  return (
    <svg viewBox="0 0 64 64" width={size} height={size} style={style} aria-hidden="true">
      <rect x="10" y="40" width="36" height="12" rx="2.5" fill={color} opacity="0.25" />
      <rect x="16" y="29" width="36" height="12" rx="2.5" fill={color} opacity="0.55" />
      <rect x="22" y="18" width="36" height="12" rx="2.5" fill={color} />
    </svg>
  );
}

/* D — Bracket k
   The most overt dev-tool mark: a terminal `[k_]`.
   Square brackets, lowercase k drawn geometrically, blinking cursor. */
function MarkBracket({ size = 64, color = GREEN, style }) {
  return (
    <svg viewBox="0 0 64 64" width={size} height={size} style={style} aria-hidden="true">
      {/* left bracket */}
      <path d="M18 12 L10 12 L10 52 L18 52"
        stroke={color} strokeWidth="5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      {/* right bracket */}
      <path d="M46 12 L54 12 L54 52 L46 52"
        stroke={color} strokeWidth="5" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      {/* k */}
      <rect x="22" y="14" width="5" height="36" rx="2.5" fill={color} />
      <path d="M27 32 L38 22" stroke={color} strokeWidth="5" strokeLinecap="round" fill="none" />
      <path d="M27 32 L38 42" stroke={color} strokeWidth="5" strokeLinecap="round" fill="none" />
    </svg>
  );
}

/* E — Card with swipe trail
   A small card on the left emitting three motion lines to the right.
   Almost a wifi/broadcast metaphor — "portable financial intelligence". */
function MarkCardTrail({ size = 64, color = GREEN, style }) {
  return (
    <svg viewBox="0 0 64 64" width={size} height={size} style={style} aria-hidden="true">
      <rect x="10" y="22" width="24" height="20" rx="3" fill={color} />
      {/* mag-stripe */}
      <rect x="10" y="27" width="24" height="2" fill="rgba(0,0,0,0.35)" />
      {/* trails */}
      <path d="M40 26 L54 26" stroke={color} strokeWidth="3" strokeLinecap="round" />
      <path d="M40 32 L50 32" stroke={color} strokeWidth="3" strokeLinecap="round" opacity="0.7" />
      <path d="M40 38 L54 38" stroke={color} strokeWidth="3" strokeLinecap="round" opacity="0.45" />
    </svg>
  );
}

/* ──────── WORDMARKS ──────── */

/* Standard wordmark: "kaskas" Inter tight, optional trailing cursor */
function Wordmark({
  size = 56,
  color = "#0f172a",
  accent = GREEN,
  cursor = false,
  weight = 700,
  tracking = "-0.045em",
  font = "Inter",
}) {
  return (
    <span style={{
      display: "inline-flex", alignItems: "baseline", gap: size * 0.08,
      fontFamily: `${font}, -apple-system, BlinkMacSystemFont, sans-serif`,
      fontWeight: weight,
      fontSize: size,
      lineHeight: 1,
      letterSpacing: tracking,
      color,
      fontFeatureSettings: '"cv11","ss01","ss03"',
    }}>
      <span>kaskas</span>
      {cursor && (
        <span style={{
          display: "inline-block",
          width: size * 0.55,
          height: size * 0.12,
          background: accent,
          borderRadius: 2,
          transform: `translateY(-${size * 0.05}px)`,
        }} />
      )}
    </span>
  );
}

/* ──────── COMPOSED LOGOS (mark + wordmark) ──────── */

function Lockup({
  Mark = MarkSwipeK,
  size = 56,
  color = "#0f172a",
  markColor,
  accent = GREEN,
  gap = 0.32,        // gap as fraction of size
  cursor = false,
}) {
  return (
    <div style={{
      display: "inline-flex", alignItems: "center", gap: size * gap,
    }}>
      <Mark size={size * 1.05} color={markColor ?? accent} />
      <Wordmark size={size} color={color} accent={accent} cursor={cursor} />
    </div>
  );
}

/* GitHub avatar — rounded-square tile with mark centered */
function AvatarTile({
  Mark = MarkSwipeK, size = 256, bg = "#0b0f12", color = GREEN,
  rounded = 0.22,
}) {
  return (
    <div style={{
      width: size, height: size, borderRadius: size * rounded,
      background: bg,
      display: "grid", placeItems: "center",
      boxShadow: "inset 0 0 0 1px rgba(255,255,255,0.04)",
    }}>
      <Mark size={size * 0.62} color={color} />
    </div>
  );
}

Object.assign(window, {
  MarkSwipeK, MarkChevron, MarkStack, MarkBracket, MarkCardTrail,
  Wordmark, Lockup, AvatarTile, KASKAS_GREEN: GREEN,
});
