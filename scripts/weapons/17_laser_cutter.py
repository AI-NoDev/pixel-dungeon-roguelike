#!/usr/bin/env python3
"""Laser Cutter — basic red laser gun (Uncommon)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (WeaponPalette, new_canvas, draw_rarity_border, save_frame)
from _extra_shapes import draw_laser

PALETTE = WeaponPalette.from_hex(
    main="#37474F",
    highlight="#90A4AE",
    shadow="#1A1A2E",
    accent="#FF1744",
    glow="#FF1744",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: laser_cutter")
    img = new_canvas(24)
    draw_laser(img, PALETTE)
    draw_rarity_border(img, "uncommon")
    save_frame(img, OUT_DIR, "weapon_laser_cutter")
    print("  ✓ laser_cutter complete")
