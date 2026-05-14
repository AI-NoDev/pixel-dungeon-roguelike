#!/usr/bin/env python3
"""Tar Slime — glossy black oily slime."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#212121",
    highlight="#FFFFFF",   # strong oily highlights
    shadow="#0D0D0D",
    eye="#FFEB3B",         # yellow glowing eyes (creepy contrast)
    accent="#424242",
    extra="#1A1A2E",       # drips
)


def add_oil_shine(img, palette, frame=0, **kwargs):
    """Add multiple oily white highlights."""
    draw = ImageDraw.Draw(img)

    # Multiple shine spots (oily look)
    shine_positions = [
        [(4, 7), (10, 8)],
        [(5, 7), (9, 8)],
        [(4, 8), (10, 7)],
        [(5, 8), (9, 7)],
    ]
    for x, y in shine_positions[frame % len(shine_positions)]:
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.highlight)

    # Drip from bottom
    drip_positions = [
        [],
        [(8, 14)],
        [(8, 14), (8, 15)],
        [(8, 15)],
    ]
    for x, y in drip_positions[frame % len(drip_positions)]:
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.extra)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="tar",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_oil_shine,
    )
