#!/usr/bin/env python3
"""Long Bow — wooden longbow (Uncommon)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_sniper_bow, draw_rarity_border, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#5D4037",      # dark wood
    highlight="#8D6E63",
    shadow="#3E2723",
    accent="#A1887F",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: long_bow")
    img = new_canvas(24)
    draw_sniper_bow(img, PALETTE)
    draw_rarity_border(img, "uncommon")
    save_frame(img, OUT_DIR, "weapon_long_bow")
    print("  ✓ long_bow complete")
