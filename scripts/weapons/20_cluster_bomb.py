#!/usr/bin/env python3
"""Cluster Bomb — multi-rocket launcher (Epic)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (WeaponPalette, new_canvas, draw_rarity_border, save_frame)
from _extra_shapes import draw_rocket

PALETTE = WeaponPalette.from_hex(
    main="#BF360C",
    highlight="#FF6F00",
    shadow="#7F0000",
    accent="#FFD700",
    glow="#FFEB3B",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: cluster_bomb")
    img = new_canvas(24)
    draw_rocket(img, PALETTE)
    draw_rarity_border(img, "epic")
    save_frame(img, OUT_DIR, "weapon_cluster_bomb")
    print("  ✓ cluster_bomb complete")
