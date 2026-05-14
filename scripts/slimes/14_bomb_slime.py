#!/usr/bin/env python3
"""Bomb Slime — red kamikaze slime wrapped in TNT with burning fuse."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations, draw_eyes
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#FF5722",
    highlight="#FFAB91",
    shadow="#BF360C",
    eye="#000000",
    accent="#FFEB3B",  # TNT yellow
    extra="#FFFFFF",   # fuse
)


def add_bomb_details(img, palette, frame=0, **kwargs):
    """Add TNT stripes and burning fuse."""
    draw = ImageDraw.Draw(img)

    # TNT yellow stripe across body
    for x in range(4, 13):
        draw.point((x, 11), fill=palette.accent)
        draw.point((x, 12), fill=palette.shadow)

    # Black bands on yellow (TNT pattern)
    for x in [5, 8, 11]:
        draw.point((x, 11), fill=(0, 0, 0, 255))

    # Burning fuse on top
    fuse_x = 8
    draw.point((fuse_x, 5), fill=palette.extra)  # white fuse line
    draw.point((fuse_x, 4), fill=palette.extra)
    draw.point((fuse_x, 3), fill=palette.extra)

    # Spark at top of fuse (animated)
    spark_positions = [
        [(fuse_x, 2)],
        [(fuse_x - 1, 2), (fuse_x + 1, 2)],
        [(fuse_x, 1)],
        [(fuse_x, 2), (fuse_x - 1, 1)],
    ]
    for x, y in spark_positions[frame % len(spark_positions)]:
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.accent)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="bomb",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_bomb_details,
    )
