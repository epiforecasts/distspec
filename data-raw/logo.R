## Generate the distspec hex logo (man/figures/logo.svg).
## Motif: a discretised PMF (bars, the fixed distribution) with a fan of
## translucent gamma curves over it (uncertain parameters).
##
## After editing, regenerate the SVG and re-render the PNG with:
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

## discretised PMF bars: gamma with mean 4, sd 2 (shape 4, rate 1)
ints <- 0:10
pmf <- pgamma(ints + 1, 4, 1) - pgamma(ints, 4, 1)
bw <- 0.8 * (x1 - x0) / xmax
bars <- sprintf(
  paste0(
    '  <rect x="%.1f" y="%.1f" width="%.1f" height="%.1f" rx="10"',
    ' fill="#2196C4" opacity="0.72"/>'
  ),
  px(ints + 0.1), py(pmf), bw, base - py(pmf)
)

## fan of curves with jittered parameters
shapes <- c(3.1, 3.6, 4.0, 4.6, 5.3)
rates <- c(0.82, 0.93, 1.00, 1.10, 1.22)
xs <- seq(0, xmax, by = 0.05)
curve_path <- function(shape, rate) {
  d <- dgamma(xs, shape, rate)
  paste0("M", paste(sprintf("%.1f %.1f", px(xs), py(d)), collapse = " L"))
}
curves <- vapply(seq_along(shapes), function(i) {
  central <- shapes[i] == 4.0
  sprintf(
    paste0(
      '  <path d="%s" fill="none" stroke="#DE8E00" stroke-width="%d"',
      ' stroke-linecap="round" opacity="%.2f"/>'
    ),
    curve_path(shapes[i], rates[i]), if (central) 14 else 9,
    if (central) 0.95 else 0.45
  )
}, character(1))

svg <- c(
  sprintf(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 %d %d">', W, H
  ),
  "  <defs>",
  '    <linearGradient id="bg" x1="0" y1="0" x2="0" y2="1">',
  '      <stop offset="0" stop-color="#FFFFFF"/>',
  '      <stop offset="1" stop-color="#E7F0F8"/>',
  "    </linearGradient>",
  sprintf(
    '    <clipPath id="hexclip"><polygon points="%s"/></clipPath>', hex_pts
  ),
  "  </defs>",
  sprintf('  <polygon points="%s" fill="url(#bg)"/>', hex_pts),
  '  <g clip-path="url(#hexclip)">',
  sprintf(
    paste0(
      '  <line x1="%d" y1="%d" x2="%d" y2="%d" stroke="#B9CCDE"',
      ' stroke-width="6" opacity="0.6"/>'
    ),
    x0 - 40, base, x1 + 40, base
  ),
  bars,
  curves,
  "  </g>",
  paste0(
    '  <text x="', cx, '" y="1610" text-anchor="middle" ',
    'font-family="Fira Sans, sans-serif" font-weight="600" ',
    'font-size="240" fill="#16283F">dist',
    '<tspan fill="#1682B0">spec</tspan></text>'
  ),
  sprintf(
    '  <polygon points="%s" fill="none" stroke="#1682B0" stroke-width="26"/>',
    hex_pts
  ),
  "</svg>"
)

writeLines(svg, "man/figures/logo.svg")
