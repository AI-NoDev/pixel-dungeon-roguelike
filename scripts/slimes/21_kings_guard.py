#!/usr/bin/env python3
"""King's Guard — purple slime with small crown and orbiting acid orbs."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#9C27B0",
    highlight="#BA68C8",
    shadow="#4A148C",
    eye="#FFFFFF",
    accent="#FFD700",   # gold crown
    extra="#76FF03",    # green acid orbs
)


def add_royal_decor(img, palette, frame=0, **kwargs):
    """Add small crown and orbiting acid orbs."""
    draw = ImageDraw.Draw(img)

    # Small crown on top
    crown_y = 5
    for x in range(9, 15):
        draw.point((x, crown_y), fill=palette.accent)
    # Crown points
    for x in [9, 11, 13]:
        draw.point((x, crown_y - 1), fill=palette.accent)

    # Acid orbs orbiting (4 positions, rotating per frame)
    orb_positions = [
        [(2, 12), (12, 2), (22, 12), (12, 22)],   # cardinal
        [(5, 5), (19, 5), (19, 19), (5, 19)],     # diagonal
        [(2, 12), (12, 2), (22, 12), (12, 22)],   # cardinal
        [(5, 5), (19, 5), (19, 19), (5, 19)],     # diagonal
    ]
    for x, y in orb_positions[frame % len(orb_positions)]:
        if 0 <= x < img.width and 0 <= y < img.height:
            # 2x2 orb
            draw.rectangle([x, y, x + 1, y + 1], fill=palette.extra)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="guard",
        canvas_size=24,
        body_w=14,
        body_h=10,
        extra_decorate=add_royal_decor,
    )
