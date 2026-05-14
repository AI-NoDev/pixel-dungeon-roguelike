#!/usr/bin/env python3
"""Throwing Knives — basic knife trio (Common)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (WeaponPalette, new_canvas, draw_rarity_border, save_frame)
from _extra_shapes import draw_knife

PALETTE = WeaponPalette.from_hex(
    main="#B0BEC5",
    highlight="#FFFFFF",
    shadow="#37474F",
    accent="#5D4037",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: throwing_knives")
    img = new_canvas(24)
    draw_knife(img, PALETTE)
    draw_rarity_border(img, "common")
    save_frame(img, OUT_DIR, "weapon_throwing_knives")
    print("  ✓ throwing_knives complete")
