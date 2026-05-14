#!/usr/bin/env python3
"""Lava Bubbler — red molten slime with magma cracks and smoke."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#FF5722",
    highlight="#FFEB3B",
    shadow="#BF360C",
    eye="#FFEB3B",        # fire eyes
    accent="#FFA000",     # magma cracks
    extra="#9E9E9E",      # smoke
)


def add_lava_effects(img, palette, frame=0, **kwargs):
    """Add magma cracks and smoke wisps."""
    draw = ImageDraw.Draw(img)

    # Magma cracks (alternate brightness per frame for pulsing)
    bright = (frame % 2) == 0
    crack_color = palette.accent if bright else palette.shadow
    cracks = [(5, 10), (9, 11), (7, 12)]
    for x, y in cracks:
        draw.point((x, y), fill=crack_color)

    # Smoke from top
    smoke_positions = [
        [(7, 4), (8, 3)],
        [(8, 3), (7, 2)],
        [(7, 2), (8, 1)],
        [(8, 4)],
    ]
    for x, y in smoke_positions[frame % len(smoke_positions)]:
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
        species_id="lava",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_lava_effects,
    )
