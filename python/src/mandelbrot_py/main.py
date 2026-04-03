from mandelbrot_py.mandelbrot import (
    WIDTH,
    HEIGHT,
    mandelbrot,
    color,
    pixel_to_complex,
)


def main() -> None:
    lines: list[str] = []
    lines.append("P3\n")
    lines.append(f"{WIDTH} {HEIGHT}\n")
    lines.append("255\n")

    for row in range(HEIGHT):
        for col in range(WIDTH):
            cx, cy = pixel_to_complex(row, col)
            n = mandelbrot(cx, cy)
            r, g, b = color(n)
            lines.append(f"{r} {g} {b}\n")

    with open("mandelbrot.ppm", "wb") as f:
        f.write("".join(lines).encode("ascii"))

    print("Written mandelbrot.ppm")


if __name__ == "__main__":
    main()
