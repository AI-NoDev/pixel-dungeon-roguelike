#!/usr/bin/env python3
"""Inferno Wand — fire wand (Rare)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_staff, draw_rarity_border,
    add_glow_effect, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#FF5722",       # red flame crystal
    highlight="#FFAB91",
    shadow="#7F0000",
    accent="#FFD700",     # gold trim
    glow="#FFEB3B",       # yellow flame
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: inferno_wand")
    img = new_canvas(24)
    draw_staff(img, PALETTE)
    # Extra flame particles around crystal
    add_glow_effect(img, PALETTE, positions=[
        (8, 5), (16, 5), (12, 3), (8, 8), (16, 8)
    ])
    draw_rarity_border(img, "rare")
    save_frame(img, OUT_DIR, "weapon_inferno_wand")
    print("  ✓ inferno_wand complete")
