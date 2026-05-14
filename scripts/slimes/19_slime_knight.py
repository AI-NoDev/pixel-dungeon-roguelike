#!/usr/bin/env python3
"""Slime Knight — armored crimson slime (24x24 elite)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#C2185B",
    highlight="#E91E63",
    shadow="#880E4F",
    eye="#FFFFFF",
    accent="#BDBDBD",   # silver armor
    extra="#FFD700",    # gold trim
)


def add_armor(img, palette, frame=0, **kwargs):
    """Add silver armor, helmet, and sword."""
    draw = ImageDraw.Draw(img)

    # Helmet (top)
    helmet_y = 4
    for x in range(9, 15):
        draw.point((x, helmet_y), fill=palette.accent)
    for x in range(8, 16):
        draw.point((x, helmet_y + 1), fill=palette.accent)
    # Helmet feather (gold)
    draw.point((11, 2), fill=palette.extra)
    draw.point((12, 3), fill=palette.extra)

    # Chest armor
    for x in range(8, 16):
        for y in range(13, 16):
            if (x + y) % 2 == 0:
                draw.point((x, y), fill=palette.accent)

    # Gold trim
    for x in range(9, 15):
        draw.point((x, 12), fill=palette.extra)

    # Tiny sword on right
    sword_x = 18
    for y in range(8, 14):
        draw.point((sword_x, y), fill=palette.accent)
    draw.point((sword_x, 7), fill=palette.extra)  # gold pommel


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="knight",
        canvas_size=24,
        body_w=14,
        body_h=10,
        extra_decorate=add_armor,
    )
