"""複数の画像（PPM/PNG 等）を横に並べて 1 枚の PNG にする比較用ツール。"""

from __future__ import annotations

import argparse
import sys

from PIL import Image


def _load_rgba(path: str) -> Image.Image:
    im = Image.open(path)
    if im.mode != "RGBA":
        return im.convert("RGBA")
    return im


def _resize_to_height(im: Image.Image, target_h: int) -> Image.Image:
    if im.height == target_h:
        return im
    w = max(1, round(im.width * target_h / im.height))
    return im.resize((w, target_h), Image.Resampling.NEAREST)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Load images (PPM, PNG, …) and place them side by side in one PNG."
    )
    parser.add_argument(
        "images",
        nargs="+",
        metavar="PATH",
        help="input image paths (order = left to right)",
    )
    parser.add_argument(
        "-o",
        "--output",
        default="comparison.png",
        metavar="PATH",
        help="output PNG path (default: comparison.png)",
    )
    parser.add_argument(
        "--padding",
        type=int,
        default=8,
        metavar="PX",
        help="gap between panels in pixels (default: 8)",
    )
    parser.add_argument(
        "--align-height",
        action="store_true",
        help="resize each image to the same height (max of all heights)",
    )
    args = parser.parse_args()

    if args.padding < 0:
        print("Error: --padding must be >= 0", file=sys.stderr)
        sys.exit(1)

    panels: list[Image.Image] = [_load_rgba(p) for p in args.images]

    if args.align_height:
        target_h = max(im.height for im in panels)
        panels = [_resize_to_height(im, target_h) for im in panels]

    total_w = sum(im.width for im in panels) + args.padding * (len(panels) - 1)
    max_h = max(im.height for im in panels)

    out = Image.new("RGBA", (total_w, max_h), (255, 255, 255, 255))
    x = 0
    for im in panels:
        y = (max_h - im.height) // 2
        out.paste(im, (x, y))
        x += im.width + args.padding

    out.save(args.output)
    print(f"Written {args.output}")


if __name__ == "__main__":
    main()
