#!/usr/bin/env python3
"""Phantom Slime — semi-transparent purple ghost slime."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette(
    main=(179, 157, 219, 130),       # 50% alpha purple
    highlight=(225, 190, 231, 180),
    shadow=(94, 53, 177, 180),
    eye=(255, 255, 255, 220),         # white glowing eyes
    accent=(225, 190, 231, 100),      # mist
)


def add_mist(img, palette, frame=0, **kwargs):
    """Add ghostly mist trails."""
    draw = ImageDraw.Draw(img)

    # Floating mist particles
    mist_positions = [
        [(2, 5), (13, 7), (4, 14)],
        [(3, 4), (12, 6), (5, 13)],
        [(2, 6), (14, 8), (3, 14)],
        [(3, 5), (13, 7), (4, 13)],
    ]
    for x, y in mist_positions[frame % len(mist_positions)]:
        if 0 <= x < img.width and 0 <= y < img.height:
            img.putpixel((x, y), palette.accent)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="phantom",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_mist,
    )
