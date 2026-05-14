#!/usr/bin/env python3
"""Crystalline Slime — semi-transparent purple crystal slime."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette(
    main=(179, 136, 255, 200),     # #B388FF 70%
    highlight=(255, 255, 255, 255),
    shadow=(49, 27, 146, 230),     # #311B92
    eye=(26, 26, 46, 255),         # #1A1A2E
    accent=(224, 64, 251, 255),    # #E040FB bright purple
    extra=(255, 215, 0, 255),       # #FFD700 occasional gold
)


def add_crystal_facets(img, palette, frame=0, **kwargs):
    """Add geometric crystal facets inside body."""
    draw = ImageDraw.Draw(img)

    # Internal facet lines (geometric pattern)
    facets = [(5, 8), (10, 9), (7, 11), (6, 10), (9, 8)]
    bright = (frame % 2) == 0
    color = palette.highlight if bright else palette.accent
    for x, y in facets:
        draw.point((x, y), fill=color)

    # Occasional gold sparkle
    if frame == 1:
        draw.point((11, 7), fill=palette.extra)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="crystal",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_crystal_facets,
    )
