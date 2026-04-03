pub const WIDTH: u32 = 800;
pub const HEIGHT: u32 = 600;

pub const X_MIN: f64 = -2.5;
pub const X_MAX: f64 = 1.0;
pub const Y_MIN: f64 = -1.3125;
pub const Y_MAX: f64 = 1.3125;

pub const MAX_ITERATIONS: u32 = 100;
pub const ESCAPE_RADIUS_SQ: f64 = 4.0;

pub const PALETTE: [(u8, u8, u8); 16] = [
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
];

pub fn mandelbrot(cx: f64, cy: f64) -> u32 {
    let mut z_re: f64 = 0.0;
    let mut z_im: f64 = 0.0;

    for i in 0..MAX_ITERATIONS {
        let z_re_sq = z_re * z_re;
        let z_im_sq = z_im * z_im;

        if z_re_sq + z_im_sq > ESCAPE_RADIUS_SQ {
            return i;
        }

        z_im = 2.0 * z_re * z_im + cy;
        z_re = z_re_sq - z_im_sq + cx;
    }

    MAX_ITERATIONS
}

pub fn color(n: u32) -> (u8, u8, u8) {
    if n == MAX_ITERATIONS {
        (0, 0, 0)
    } else {
        PALETTE[(n % 16) as usize]
    }
}

pub fn pixel_to_complex(row: u32, col: u32) -> (f64, f64) {
    let cx = X_MIN + (col as f64) * (X_MAX - X_MIN) / (WIDTH as f64);
    let cy = Y_MAX - (row as f64) * (Y_MAX - Y_MIN) / (HEIGHT as f64);
    (cx, cy)
}
