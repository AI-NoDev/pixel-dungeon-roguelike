#!/usr/bin/env python3
"""Thunder Jolt — yellow electric slime with lightning arcs."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations, draw_eyes
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#FFEB3B",
    highlight="#FFFFFF",
    shadow="#FBC02D",
    eye="#1A1A2E",
    accent="#FFFFFF",     # white sparks
    extra="#82B1FF",      # blue arcs
)


def add_lightning(img, palette, frame=0, **kwargs):
    """Add lightning arcs around the body."""
    draw = ImageDraw.Draw(img)

    # Lightning arc patterns (shift each frame for animation)
    arc_patterns = [
        [(2, 6), (1, 7), (0, 8)],   # arc out left
        [(13, 7), (14, 8), (15, 7)], # arc out right
        [(2, 11), (1, 10), (0, 9)],  # arc lower-left
        [(13, 11), (14, 10), (15, 9)], # arc lower-right
    ]
    arcs = arc_patterns[frame % len(arc_patterns)]
    for x, y in arcs:
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.extra)


def add_excited_eyes(img, palette, **kwargs):
    """Override default eyes with excited O.O eyes."""
    draw_eyes(img, palette, eye_y=10, excited=True)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="thunder",
        canvas_size=16,
        body_w=12,
        body_h=8,
        extra_decorate=add_lightning,
    )
