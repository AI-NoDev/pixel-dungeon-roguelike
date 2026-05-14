#!/usr/bin/env python3
"""Mega Goo — large teal tank slime, 24x24 canvas."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#4DB6AC",
    highlight="#80CBC4",
    shadow="#00695C",
    eye="#000000",
    accent="#26A69A",  # mid-tone fold lines
)


def add_jelly_folds(img, palette, frame=0, **kwargs):
    """Add multiple jelly fold lines."""
    draw = ImageDraw.Draw(img)
    # Horizontal fold lines (chubby effect)
    folds = [(8, 14), (9, 14), (10, 14), (11, 14), (12, 14), (13, 14), (14, 14)]
    for x, y in folds:
        draw.point((x, y), fill=palette.accent)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="mega",
        canvas_size=24,    # larger canvas
        body_w=18,
        body_h=12,
        extra_decorate=add_jelly_folds,
    )
