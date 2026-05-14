#!/usr/bin/env python3
"""Acid Spitter — yellow slime that drips toxic acid."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#FFEE58",
    highlight="#FFFF8D",
    shadow="#F57F17",
    eye="#1A1A2E",
    accent="#76FF03",  # toxic green spots
    extra="#69F0AE",   # acid drip green
)


def add_acid(img, palette, frame=0, **kwargs):
    """Add toxic green spots and dripping acid."""
    draw = ImageDraw.Draw(img)
    # Toxic spots on body (visible most frames)
    spots = [(5, 8), (10, 9), (7, 6)]
    for x, y in spots:
        draw.point((x, y), fill=palette.accent)

    # Drip from mouth (changes per frame)
    drip_positions = [
        [(8, 14)],         # tiny drip
        [(8, 14), (8, 15)],  # falling
        [],                # detached
        [(8, 13)],          # forming new
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
        species_id="acid",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_acid,
    )
