#!/usr/bin/env python3
"""Generate Green Slime sprites.

The classic dungeon slime monster. Bright green, friendly, basic.

Usage:
    python3 01_green_slime.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from _pixel_lib import (
    SlimePalette,
    generate_all_animations,
)


PALETTE = SlimePalette.from_hex(
    main="#66BB6A",
    highlight="#A5D6A7",
    shadow="#2E7D32",
    eye="#000000",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="green",
        canvas_size=16,
        body_w=12,
        body_h=8,
    )
