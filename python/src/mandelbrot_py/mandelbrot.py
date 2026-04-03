WIDTH: int = 800
HEIGHT: int = 600

X_MIN: float = -2.5
X_MAX: float = 1.0
Y_MIN: float = -1.3125
Y_MAX: float = 1.3125

MAX_ITERATIONS: int = 100
ESCAPE_RADIUS_SQ: float = 4.0

PALETTE: list[tuple[int, int, int]] = [
    (66, 30, 15),
    (25, 7, 26),
    (9, 1, 47),
    (4, 4, 73),
    (0, 7, 100),
    (12, 44, 138),
    (24, 82, 177),
    (57, 125, 209),
    (134, 181, 229),
    (211, 236, 248),
    (241, 233, 191),
    (248, 201, 95),
    (255, 170, 0),
    (204, 128, 0),
    (153, 87, 0),
    (106, 52, 3),
]


def mandelbrot(cx: float, cy: float) -> int:
    z_re: float = 0.0
    z_im: float = 0.0

    for i in range(MAX_ITERATIONS):
        z_re_sq = z_re * z_re
        z_im_sq = z_im * z_im

        if z_re_sq + z_im_sq > ESCAPE_RADIUS_SQ:
            return i

        z_im = 2.0 * z_re * z_im + cy
        z_re = z_re_sq - z_im_sq + cx

    return MAX_ITERATIONS


def color(n: int) -> tuple[int, int, int]:
    if n == MAX_ITERATIONS:
        return (0, 0, 0)
    return PALETTE[n % 16]


def pixel_to_complex(row: int, col: int) -> tuple[float, float]:
    cx = X_MIN + col * (X_MAX - X_MIN) / WIDTH
    cy = Y_MAX - row * (Y_MAX - Y_MIN) / HEIGHT
    return (cx, cy)
