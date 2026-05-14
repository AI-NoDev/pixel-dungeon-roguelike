#!/usr/bin/env python3
"""Iron Pistol — basic gray pistol (Common)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_pistol, draw_rarity_border, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#9E9E9E",       # iron gray
    highlight="#E0E0E0",
    shadow="#424242",
    accent="#5D4037",     # wood grip
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: iron_pistol")
    img = new_canvas(24)
    draw_pistol(img, PALETTE)
    draw_rarity_border(img, "common")
    save_frame(img, OUT_DIR, "weapon_iron_pistol")
    print("  ✓ iron_pistol complete")
