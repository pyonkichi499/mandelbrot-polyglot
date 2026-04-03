import pytest

from mandelbrot_py.mandelbrot import (
    WIDTH,
    HEIGHT,
    MAX_ITERATIONS,
    mandelbrot,
    color,
    pixel_to_complex,
)


def test_定数が仕様通り() -> None:
    assert WIDTH == 800
    assert HEIGHT == 600
    assert MAX_ITERATIONS == 100


def test_原点は集合の内部() -> None:
    assert mandelbrot(0.0, 0.0) == 100


def test_マイナス1は集合の内部() -> None:
    assert mandelbrot(-1.0, 0.0) == 100


def test_遠方の点はすぐ発散() -> None:
    assert mandelbrot(2.0, 0.0) == 2


def test_境界付近の点() -> None:
    assert mandelbrot(1.0, 0.0) == 3


def test_左端外の点() -> None:
    assert mandelbrot(-2.1, 0.0) == 1


def test_複素平面上の点() -> None:
    assert mandelbrot(0.5, 0.5) == 5


def test_集合内の点は黒() -> None:
    assert color(100) == (0, 0, 0)


def test_パレットの循環() -> None:
    assert color(0) == color(16)


def test_ピクセル座標の左上() -> None:
    cx, cy = pixel_to_complex(0, 0)
    assert cx == pytest.approx(-2.5, abs=1e-9)
    assert cy == pytest.approx(1.3125, abs=1e-9)


def test_ピクセル座標の原点付近() -> None:
    cx, cy = pixel_to_complex(300, 571)
    assert cx == pytest.approx(0.0, abs=0.01)
    assert cy == pytest.approx(0.0, abs=0.01)
