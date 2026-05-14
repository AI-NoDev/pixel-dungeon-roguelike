#!/usr/bin/env python3
"""Compound Bow — modern compound bow (Uncommon)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (WeaponPalette, new_canvas, draw_rarity_border, save_frame)
from _extra_shapes import draw_compound_bow

PALETTE = WeaponPalette.from_hex(
    main="#5D4037",
    highlight="#A1887F",
    shadow="#3E2723",
    accent="#8D6E63",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: compound_bow")
    img = new_canvas(24)
    draw_compound_bow(img, PALETTE)
    draw_rarity_border(img, "uncommon")
    save_frame(img, OUT_DIR, "weapon_compound_bow")
    print("  ✓ compound_bow complete")
