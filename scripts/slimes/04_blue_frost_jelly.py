#!/usr/bin/env python3
"""Blue Frost Jelly — translucent ice blue slime with frost particles."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

# Semi-transparent body (180/255 = 70%)
PALETTE = SlimePalette(
    main=(79, 195, 247, 200),       # #4FC3F7 70% alpha
    highlight=(225, 245, 254, 220),  # #E1F5FE
    shadow=(1, 87, 155, 220),        # #01579B
    eye=(13, 71, 161, 255),          # #0D47A1 navy
    accent=(255, 255, 255, 255),     # ice crystals
    extra=(255, 255, 255, 200),      # snowflakes
)


def add_ice(img, palette, frame=0, **kwargs):
    """Add internal ice crystals and floating snowflakes."""
    draw = ImageDraw.Draw(img)

    # Internal ice crystal shards
    crystals = [(5, 9), (10, 10), (8, 11)]
    for x, y in crystals:
        draw.point((x, y), fill=palette.accent)

    # Snowflakes around
    snow_positions = [
        [(2, 3), (13, 4), (4, 13)],
        [(1, 5), (14, 6), (3, 14)],
        [(3, 2), (12, 5), (5, 12)],
        [(2, 6), (13, 3), (4, 13)],
    ]
    for x, y in snow_positions[frame % len(snow_positions)]:
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
        species_id="frost",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_ice,
    )
