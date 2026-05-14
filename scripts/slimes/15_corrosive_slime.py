#!/usr/bin/env python3
"""Corrosive Slime — dark brown sludge with toxic green spots."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#5D4037",
    highlight="#8D6E63",
    shadow="#3E2723",
    eye="#76FF03",   # bright green eyes
    accent="#76FF03",  # green spots
    extra="#69F0AE",   # acid drips
)


def add_corrosion(img, palette, frame=0, **kwargs):
    """Add toxic green spots and corrosive drips."""
    draw = ImageDraw.Draw(img)

    # Toxic green spots scattered on body
    spots = [(4, 8), (10, 9), (7, 11), (12, 8)]
    for x, y in spots:
        draw.point((x, y), fill=palette.accent)

    # Corrosive drips
    drip_positions = [
        [(8, 14)],
        [(8, 14), (8, 15)],
        [(7, 14)],
        [(8, 13)],
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
        species_id="corrosive",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_corrosion,
    )
