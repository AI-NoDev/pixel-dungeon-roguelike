#!/usr/bin/env python3
"""Toxic Goo — sickly green-purple poison slime."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#9CCC65",
    highlight="#DCEDC8",
    shadow="#33691E",
    eye="#4A148C",
    accent="#6A1B9A",  # purple toxic spots
    extra="#7B1FA2",   # purple gas
    main_alpha=255,
)


def add_toxic_bubbles(img, palette, frame=0, **kwargs):
    """Add toxic spots and rising gas bubbles."""
    draw = ImageDraw.Draw(img)

    # Purple toxic spots
    spots = [(4, 8), (10, 9), (7, 11), (12, 8)]
    for x, y in spots:
        draw.point((x, y), fill=palette.accent)

    # Rising bubbles from top (cycle)
    bubble_positions = [
        [(7, 4), (9, 3)],
        [(8, 3), (6, 2)],
        [(7, 2), (9, 1)],
        [(8, 5)],
    ]
    for x, y in bubble_positions[frame % len(bubble_positions)]:
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
        species_id="toxic",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_toxic_bubbles,
    )
