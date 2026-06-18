use mandelbrot_lib::mandelbrot::{
    color, mandelbrot, dimensions, pixel_to_complex, BASE_HEIGHT, BASE_WIDTH, DEFAULT_SCALE,
    HEIGHT, MAX_ITERATIONS, WIDTH,
};

#[test]
fn test_定数が仕様通り() {
    assert_eq!(BASE_WIDTH, 800);
    assert_eq!(BASE_HEIGHT, 600);
    assert_eq!(DEFAULT_SCALE, 2);
    assert_eq!(WIDTH, 1600);
    assert_eq!(HEIGHT, 1200);
    assert_eq!(MAX_ITERATIONS, 100);
}

#[test]
fn test_原点は集合の内部() {
    assert_eq!(mandelbrot(0.0, 0.0), 100);
}

#[test]
fn test_マイナス1は集合の内部() {
    assert_eq!(mandelbrot(-1.0, 0.0), 100);
}

#[test]
fn test_遠方の点はすぐ発散() {
    assert_eq!(mandelbrot(2.0, 0.0), 2);
}

#[test]
fn test_境界付近の点() {
    assert_eq!(mandelbrot(1.0, 0.0), 3);
}

#[test]
fn test_左端外の点() {
    assert_eq!(mandelbrot(-2.1, 0.0), 1);
}

#[test]
fn test_複素平面上の点() {
    assert_eq!(mandelbrot(0.5, 0.5), 5);
}

#[test]
fn test_集合内の点は黒() {
    assert_eq!(color(MAX_ITERATIONS), (0, 0, 0));
}

#[test]
fn test_パレットの循環() {
    assert_eq!(color(0), color(16));
}

#[test]
fn test_スケールごとの解像度() {
    assert_eq!(dimensions(1), (800, 600));
    assert_eq!(dimensions(2), (1600, 1200));
    assert_eq!(dimensions(3), (2400, 1800));
}

#[test]
fn test_ピクセル座標の左上() {
    let (cx, cy) = pixel_to_complex(0, 0, WIDTH, HEIGHT);
    assert!((cx - (-2.5)).abs() < 1e-10, "cx = {cx}, expected -2.5");
    assert!((cy - 1.3125).abs() < 1e-10, "cy = {cy}, expected 1.3125");
}

#[test]
fn test_ピクセル座標の原点付近() {
    let (cx, cy) = pixel_to_complex(600, 1142, WIDTH, HEIGHT);
    assert!(cx.abs() < 0.01, "cx = {cx}, expected close to 0.0");
    assert!(cy.abs() < 0.01, "cy = {cy}, expected close to 0.0");
}
