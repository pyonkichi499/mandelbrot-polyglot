use mandelbrot_lib::mandelbrot::{
    color, mandelbrot, pixel_to_complex, HEIGHT, MAX_ITERATIONS, WIDTH,
};

#[test]
fn test_定数が仕様通り() {
    assert_eq!(WIDTH, 800);
    assert_eq!(HEIGHT, 600);
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
fn test_ピクセル座標の左上() {
    let (cx, cy) = pixel_to_complex(0, 0);
    assert!((cx - (-2.5)).abs() < 1e-10, "cx = {cx}, expected -2.5");
    assert!((cy - 1.3125).abs() < 1e-10, "cy = {cy}, expected 1.3125");
}

#[test]
fn test_ピクセル座標の原点付近() {
    let (cx, cy) = pixel_to_complex(300, 571);
    assert!(cx.abs() < 0.01, "cx = {cx}, expected close to 0.0");
    assert!(cy.abs() < 0.01, "cy = {cy}, expected close to 0.0");
}
