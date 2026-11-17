## Generate the distspec hex logo (man/figures/logo.svg) and its dark-mode
## version (man/figures/logo-dark.svg).
## Motif: a discretised PMF (bars, the fixed distribution) with a fan of
## translucent gamma curves over it (uncertain parameters).
##
## After editing, regenerate the SVGs and re-render the PNG with:
##   Rscript data-raw/logo.R
##   inkscape man/figures/logo.svg --export-type=png \
##     --export-filename=man/figures/logo.png -w 240 -h 277

W <- 1732
H <- 2000
cx <- W / 2
cy <- H / 2

## pointy-top hexagon, inset so the border stroke sits inside the canvas
inset <- 20
R <- cy - inset
hx <- function(a) cx + R * sin(a)
hy <- function(a) cy - R * cos(a)
angles <- seq(0, 5) * pi / 3
hex_pts <- paste(sprintf("%.1f,%.1f", hx(angles), hy(angles)), collapse = " ")

## plot region inside the hexagon
x0 <- 330
x1 <- 1440
base <- 1240
yscale <- 3100 # px per unit density

xmax <- 11.5
px <- function(x) x0 + x / xmax * (x1 - x0)
py <- function(d) base - d * yscale

## the same design on a light and a dark ground: on the dark one the data
## colours are lightened to keep their contrast and the baseline is darkened
## so it stays a quiet rule
themes <- list(
  light = list(
    file = "man/figures/logo.svg",
    bg_top = "#FFFFFF", bg_bottom = "#E7F0F8", baseline = "#B9CCDE",
    bars = "#2196C4", curves = "#DE8E00", text = "#16283F", accent = "#1682B0"
  ),
  dark = list(
    file = "man/figures/logo-dark.svg",
    bg_top = "#1A2430", bg_bottom = "#131A21", baseline = "#3A4D60",
    bars = "#4FB3DE", curves = "#F5A93A", text = "#F2F5F8", accent = "#6CC0E6"
  )
)

## discretised PMF bars: gamma with mean 4, sd 2 (shape 4, rate 1)
ints <- 0:10
pmf <- pgamma(ints + 1, 4, 1) - pgamma(ints, 4, 1)
bw <- 0.8 * (x1 - x0) / xmax
bars <- function(fill) {
  sprintf(
    paste0(
      '  <rect x="%.1f" y="%.1f" width="%.1f" height="%.1f" rx="10"',
      ' fill="%s" opacity="0.72"/>'
    ),
    px(ints + 0.1), py(pmf), bw, base - py(pmf), fill
  )
}

## fan of curves with jittered parameters
shapes <- c(3.1, 3.6, 4.0, 4.6, 5.3)
rates <- c(0.82, 0.93, 1.00, 1.10, 1.22)
xs <- seq(0, xmax, by = 0.05)
curve_path <- function(shape, rate) {
  d <- dgamma(xs, shape, rate)
  paste0("M", paste(sprintf("%.1f %.1f", px(xs), py(d)), collapse = " L"))
}
curves <- function(stroke) {
  vapply(seq_along(shapes), function(i) {
    central <- shapes[i] == 4.0
    sprintf(
      paste0(
        '  <path d="%s" fill="none" stroke="%s" stroke-width="%d"',
        ' stroke-linecap="round" opacity="%.2f"/>'
      ),
      curve_path(shapes[i], rates[i]), stroke, if (central) 14 else 9,
      if (central) 0.95 else 0.45
    )
  }, character(1))
}

for (theme in themes) {
  svg <- c(
    sprintf(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 %d %d">', W, H
    ),
    "  <defs>",
    '    <linearGradient id="bg" x1="0" y1="0" x2="0" y2="1">',
    sprintf('      <stop offset="0" stop-color="%s"/>', theme$bg_top),
    sprintf('      <stop offset="1" stop-color="%s"/>', theme$bg_bottom),
    "    </linearGradient>",
    sprintf(
      '    <clipPath id="hexclip"><polygon points="%s"/></clipPath>', hex_pts
    ),
    "  </defs>",
    sprintf('  <polygon points="%s" fill="url(#bg)"/>', hex_pts),
    '  <g clip-path="url(#hexclip)">',
    sprintf(
      paste0(
        '  <line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s"',
        ' stroke-width="6" opacity="0.6"/>'
      ),
      x0 - 40, base, x1 + 40, base, theme$baseline
    ),
    bars(theme$bars),
    curves(theme$curves),
    "  </g>",
    paste0(
      '  <text x="', cx, '" y="1610" text-anchor="middle" ',
      'font-family="Fira Sans, sans-serif" font-weight="600" ',
      'font-size="240" fill="', theme$text, '">dist',
      '<tspan fill="', theme$accent, '">spec</tspan></text>'
    ),
    sprintf(
      '  <polygon points="%s" fill="none" stroke="%s" stroke-width="26"/>',
      hex_pts, theme$accent
    ),
    "</svg>"
  )

  writeLines(svg, theme$file)
}
