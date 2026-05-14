#!/usr/bin/env python3
"""Slime Mage — purple wizard slime with star hat (24x24 elite)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#6A1B9A",
    highlight="#AB47BC",
    shadow="#4A148C",
    eye="#FFFFFF",
    accent="#311B92",  # darker purple hat
    extra="#FFD700",   # gold stars
)


def add_wizard_hat(img, palette, frame=0, **kwargs):
    """Add wizard hat with stars and floating staff."""
    draw = ImageDraw.Draw(img)

    # Wizard hat (pointed)
    # Wide bottom, narrowing to point
    for x in range(7, 17):
        draw.point((x, 6), fill=palette.accent)
    for x in range(8, 16):
        draw.point((x, 5), fill=palette.accent)
    for x in range(9, 15):
        draw.point((x, 4), fill=palette.accent)
    for x in range(10, 14):
        draw.point((x, 3), fill=palette.accent)
    for x in range(11, 13):
        draw.point((x, 2), fill=palette.accent)
    draw.point((11, 1), fill=palette.accent)

    # Hat band gold trim
    for x in range(7, 17):
        draw.point((x, 7), fill=palette.extra)

    # Gold stars on hat
    star_positions = [(10, 4), (13, 3), (12, 5)]
    for x, y in star_positions:
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.extra)

    # Staff floating to the right (with crystal)
    staff_x = 19
    for y in range(10, 18):
        draw.point((staff_x, y), fill=(93, 64, 55, 255))  # brown
    # Crystal top
    draw.point((staff_x, 8), fill=(224, 64, 251, 255))  # bright magenta
    draw.point((staff_x, 9), fill=(224, 64, 251, 255))


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="mage",
        canvas_size=24,
        body_w=14,
        body_h=10,
        extra_decorate=add_wizard_hat,
    )
