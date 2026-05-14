#!/usr/bin/env python3
"""Pink Bouncer — fast, hyperactive, candy-pink slime."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#F48FB1",
    highlight="#FCE4EC",
    shadow="#C2185B",
    eye="#000000",
    accent="#FFD700",
    extra="#FFFFFF",
)


def add_sparkles(img, palette, frame=0, **kwargs):
    """Add small sparkle stars around the bouncer."""
    draw = ImageDraw.Draw(img)
    # Sparkle positions cycle each frame
    positions = [
        [(2, 4), (13, 5), (4, 12)],
        [(1, 6), (14, 8), (3, 13)],
        [(3, 3), (12, 6), (5, 11)],
        [(2, 7), (13, 4), (4, 14)],
    ]
    for x, y in positions[frame % len(positions)]:
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.extra or (255, 255, 255, 255))


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="pink",
        canvas_size=16,
        body_w=10,  # smaller than green
        body_h=7,
        extra_decorate=add_sparkles,
    )
