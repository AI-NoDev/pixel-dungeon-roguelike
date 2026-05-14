#!/usr/bin/env python3
"""Slime King — golden boss slime with elaborate crown and cape (48x48)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#FFD54F",
    highlight="#FFE082",
    shadow="#FF8F00",
    eye="#1A1A2E",
    accent="#FFD700",   # crown gold
    extra="#B71C1C",    # red cape/ruby
)


def add_royal_majesty(img, palette, frame=0, **kwargs):
    """Add elaborate crown, ruby, cape, and golden orbs."""
    draw = ImageDraw.Draw(img)
    cx = img.width // 2

    # Crown band
    crown_y = 8
    for x in range(cx - 8, cx + 8):
        draw.point((x, crown_y), fill=palette.accent)
        draw.point((x, crown_y + 1), fill=palette.accent)

    # Crown points (5 spikes)
    spike_xs = [cx - 7, cx - 4, cx, cx + 3, cx + 6]
    for x in spike_xs:
        draw.point((x, crown_y - 1), fill=palette.accent)
        draw.point((x, crown_y - 2), fill=palette.accent)
    # Center spike taller
    draw.point((cx, crown_y - 3), fill=palette.accent)

    # Ruby in crown center
    draw.rectangle([cx - 1, crown_y, cx + 1, crown_y + 1], fill=palette.extra)

    # Red cape behind body
    for x in range(cx - 10, cx + 10):
        for y in range(36, 44):
            if 0 <= x < img.width and 0 <= y < img.height:
                # Cape with subtle pattern
                if (x + y) % 3 != 0:
                    draw.point((x, y), fill=palette.extra)

    # Gold orbs orbiting (4 positions)
    orb_positions = [
        [(4, 12), (44, 12), (4, 36), (44, 36)],
        [(8, 8), (40, 8), (8, 40), (40, 40)],
        [(4, 24), (44, 24), (24, 4), (24, 44)],
        [(8, 16), (40, 16), (16, 8), (32, 8)],
    ]
    for x, y in orb_positions[frame % len(orb_positions)]:
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.rectangle([x, y, x + 2, y + 2], fill=palette.accent)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="king",
        canvas_size=48,
        body_w=32,
        body_h=22,
        extra_decorate=add_royal_majesty,
    )
