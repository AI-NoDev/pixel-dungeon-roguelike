#!/usr/bin/env python3
"""Rusty Shotgun — old wooden shotgun (Common)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_shotgun, draw_rarity_border, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#8D6E63",        # brown rust
    highlight="#BCAAA4",
    shadow="#3E2723",
    accent="#5D4037",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: rusty_shotgun")
    img = new_canvas(24)
    draw_shotgun(img, PALETTE)
    draw_rarity_border(img, "common")
    save_frame(img, OUT_DIR, "weapon_rusty_shotgun")
    print("  ✓ rusty_shotgun complete")
