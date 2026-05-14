#!/usr/bin/env python3
"""Spike Slime — gray-blue slime with sharp white spikes."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette.from_hex(
    main="#607D8B",
    highlight="#B0BEC5",
    shadow="#37474F",
    eye="#FF6F00",   # orange warning eyes
    accent="#FFFFFF",  # spikes white
    extra="#FFD54F",   # gold tips
)


def add_spikes(img, palette, frame=0, **kwargs):
    """Add 8 spikes radiating from body."""
    draw = ImageDraw.Draw(img)
    cx, cy = 8, 10

    # 8 directional spikes
    spike_dirs = [
        (0, -5),   # up
        (3, -4),   # up-right
        (5, -1),   # right
        (3, 2),    # down-right (subtle)
        (-3, 2),   # down-left
        (-5, -1),  # left
        (-3, -4),  # up-left
        (0, -6),   # higher up
    ]
    for dx, dy in spike_dirs:
        x = cx + dx
        y = cy + dy
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.accent)
        # Gold tip (one further out)
        x2 = cx + int(dx * 1.3) if dx != 0 else cx
        y2 = cy + int(dy * 1.3)
        if 0 <= x2 < img.width and 0 <= y2 < img.height:
            draw.point((x2, y2), fill=palette.extra)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="spike",
        canvas_size=16,
        body_w=10,
        body_h=8,
        extra_decorate=add_spikes,
    )
