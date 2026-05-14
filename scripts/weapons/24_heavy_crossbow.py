#!/usr/bin/env python3
"""Heavy Crossbow — armored crossbow (Rare)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (WeaponPalette, new_canvas, draw_rarity_border, save_frame)
from _extra_shapes import draw_crossbow

PALETTE = WeaponPalette.from_hex(
    main="#5D4037",
    highlight="#8D6E63",
    shadow="#3E2723",
    accent="#FFD54F",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: heavy_crossbow")
    img = new_canvas(24)
    draw_crossbow(img, PALETTE)
    draw_rarity_border(img, "rare")
    save_frame(img, OUT_DIR, "weapon_heavy_crossbow")
    print("  ✓ heavy_crossbow complete")
