#!/usr/bin/env python3
"""Hunter Rifle — basic bolt-action rifle (Common)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_rifle, draw_rarity_border, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#616161",         # steel barrel
    highlight="#9E9E9E",
    shadow="#212121",
    accent="#5D4037",       # wood stock
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: hunter_rifle")
    img = new_canvas(24)
    draw_rifle(img, PALETTE)
    draw_rarity_border(img, "common")
    save_frame(img, OUT_DIR, "weapon_hunter_rifle")
    print("  ✓ hunter_rifle complete")
