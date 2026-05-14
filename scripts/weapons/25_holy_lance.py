#!/usr/bin/env python3
"""Holy Lance — divine crossbow lance (Legendary)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (WeaponPalette, new_canvas, draw_rarity_border, save_frame)
from _extra_shapes import draw_crossbow

PALETTE = WeaponPalette.from_hex(
    main="#FFD700",
    highlight="#FFFFFF",
    shadow="#FF8F00",
    accent="#FFFFFF",
    glow="#FFEB3B",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: holy_lance")
    img = new_canvas(24)
    draw_crossbow(img, PALETTE)
    draw_rarity_border(img, "legendary")
    save_frame(img, OUT_DIR, "weapon_holy_lance")
    print("  ✓ holy_lance complete")
