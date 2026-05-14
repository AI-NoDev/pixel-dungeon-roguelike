#!/usr/bin/env python3
"""Rapid Blaster — basic SMG (Common)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_smg, draw_rarity_border, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#78909C",       # military gray
    highlight="#B0BEC5",
    shadow="#37474F",
    accent="#1A1A2E",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: rapid_blaster")
    img = new_canvas(24)
    draw_smg(img, PALETTE)
    draw_rarity_border(img, "common")
    save_frame(img, OUT_DIR, "weapon_rapid_blaster")
    print("  ✓ rapid_blaster complete")
