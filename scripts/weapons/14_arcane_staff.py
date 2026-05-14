#!/usr/bin/env python3
"""Arcane Staff — magic staff with crystal (Uncommon)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_staff, draw_rarity_border, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#9C27B0",          # purple crystal
    highlight="#E1BEE7",
    shadow="#4A148C",
    accent="#FFFFFF",
    glow="#E040FB",          # magic glow
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: arcane_staff")
    img = new_canvas(24)
    draw_staff(img, PALETTE)
    draw_rarity_border(img, "uncommon")
    save_frame(img, OUT_DIR, "weapon_arcane_staff")
    print("  ✓ arcane_staff complete")
