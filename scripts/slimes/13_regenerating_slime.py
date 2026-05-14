#!/usr/bin/env python3
"""Regenerating Slime — bright green healing slime with plus signs."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#69F0AE",
    highlight="#FFFFFF",
    shadow="#1B5E20",
    eye="#1B5E20",
    accent="#A5D6A7",  # halo
    extra="#FFFFFF",   # plus signs
)


def add_healing_aura(img, palette, frame=0, **kwargs):
    """Add plus signs floating around head."""
    draw = ImageDraw.Draw(img)

    # Plus signs in different positions per frame
    plus_positions = [
        [(2, 3), (13, 4)],
        [(3, 2), (12, 3)],
        [(2, 4), (14, 3)],
        [(3, 3), (13, 2)],
    ]

    for x, y in plus_positions[frame % len(plus_positions)]:
        # Draw a plus sign (3 pixels)
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.extra)
        if 0 <= x - 1 < img.width and 0 <= y < img.height:
            draw.point((x - 1, y), fill=palette.extra)
        if 0 <= x + 1 < img.width and 0 <= y < img.height:
            draw.point((x + 1, y), fill=palette.extra)
        if 0 <= x < img.width and 0 <= y - 1 < img.height:
            draw.point((x, y - 1), fill=palette.extra)
        if 0 <= x < img.width and 0 <= y + 1 < img.height:
            draw.point((x, y + 1), fill=palette.extra)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="regen",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_healing_aura,
    )
