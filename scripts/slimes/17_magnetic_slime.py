#!/usr/bin/env python3
"""Magnetic Slime — yellow-black hazard stripe slime with N/S poles."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#FF6F00",
    highlight="#FFA726",
    shadow="#E65100",
    eye="#000000",
    accent="#1A1A2E",  # black stripes
    extra="#FFFFFF",   # field lines
)


def add_hazard_stripes(img, palette, frame=0, **kwargs):
    """Add black hazard stripes and magnet poles."""
    draw = ImageDraw.Draw(img)

    # Black diagonal hazard stripes on body
    for x in range(3, 14):
        for y in range(7, 13):
            # Diagonal pattern: x + y % 3 == 0
            if (x + y) % 3 == 0:
                draw.point((x, y), fill=palette.accent)

    # Magnetic field lines (rotating per frame)
    field_patterns = [
        [(1, 9), (15, 9)],         # horizontal
        [(8, 2), (8, 15)],         # vertical
        [(2, 4), (14, 14)],        # diagonal
        [(2, 14), (14, 4)],        # anti-diagonal
    ]
    for x, y in field_patterns[frame % len(field_patterns)]:
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
        species_id="magnetic",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_hazard_stripes,
    )
