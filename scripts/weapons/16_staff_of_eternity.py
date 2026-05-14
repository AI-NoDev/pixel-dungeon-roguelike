#!/usr/bin/env python3
"""Staff of Eternity — legendary divine staff (Legendary)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_staff, draw_rarity_border,
    add_glow_effect, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#FFD700",         # gold crystal
    highlight="#FFFFFF",
    shadow="#FF8F00",
    accent="#E040FB",       # purple inner
    glow="#FFEB3B",         # yellow halo
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: staff_of_eternity")
    img = new_canvas(24)
    draw_staff(img, PALETTE)
    # Massive divine glow particles
    add_glow_effect(img, PALETTE, positions=[
        (6, 4), (18, 4), (4, 6), (20, 6), (12, 1), (8, 8), (16, 8),
        (6, 10), (18, 10),
    ])
    draw_rarity_border(img, "legendary")
    save_frame(img, OUT_DIR, "weapon_staff_of_eternity")
    print("  ✓ staff_of_eternity complete")
