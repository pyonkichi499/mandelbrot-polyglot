import argparse
import sys

from mandelbrot_py.mandelbrot import (
    DEFAULT_SCALE,
    color,
    dimensions,
    mandelbrot,
    pixel_to_complex,
)


def default_output_path(scale: int) -> str:
    if scale == DEFAULT_SCALE:
        return "mandelbrot.ppm"
    return f"mandelbrot-{scale}x.ppm"


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Render Mandelbrot set to PPM. "
            "Scale N is relative to base 800×600 (1→800×600, 2→1600×1200, …)."
        )
    )
    parser.add_argument(
        "-s",
        "--scale",
        type=int,
        default=DEFAULT_SCALE,
        metavar="N",
        help=f"integer scale (default: {DEFAULT_SCALE})",
    )
    parser.add_argument(
        "-o",
        "--output",
        default=None,
        metavar="PATH",
        help=(
            f"output PPM path (default: mandelbrot.ppm for scale {DEFAULT_SCALE}, "
            "else mandelbrot-Nx.ppm)"
        ),
    )
    args = parser.parse_args()
    if args.scale < 1:
        print("Error: scale must be >= 1", file=sys.stderr)
        sys.exit(1)

    scale = args.scale
    path = args.output or default_output_path(scale)
    w, h = dimensions(scale)

    lines: list[str] = []
    lines.append("P3\n")
    lines.append(f"{w} {h}\n")
    lines.append("255\n")

    for row in range(h):
        for col in range(w):
            cx, cy = pixel_to_complex(row, col, w, h)
            n = mandelbrot(cx, cy)
            r, g, b = color(n)
            lines.append(f"{r} {g} {b}\n")

    with open(path, "wb") as f:
        f.write("".join(lines).encode("ascii"))

    print(f"Written {path}")


if __name__ == "__main__":
    main()
