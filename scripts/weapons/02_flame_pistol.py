#!/usr/bin/env python3
"""Flame Pistol — fire-element pistol (Uncommon)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_pistol, draw_rarity_border,
    add_glow_effect, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#5D4037",       # dark gunmetal
    highlight="#FFAB91",
    shadow="#3E2723",
    accent="#FF7043",
    glow="#FFEB3B",       # fire glow
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: flame_pistol")
    img = new_canvas(24)
    draw_pistol(img, PALETTE)
    # Add fire glow particles around barrel
    add_glow_effect(img, PALETTE, positions=[(20, 11), (21, 12), (19, 11)])
    draw_rarity_border(img, "uncommon")
    save_frame(img, OUT_DIR, "weapon_flame_pistol")
    print("  ✓ flame_pistol complete")
