#!/usr/bin/env python3
"""Void Sprayer — alien organic SMG (Epic)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_smg, draw_rarity_border,
    add_glow_effect, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#311B92",          # void purple
    highlight="#9C27B0",
    shadow="#1A1A2E",
    accent="#76FF03",        # green void core
    glow="#E040FB",          # magenta sparkle
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: void_sprayer")
    img = new_canvas(24)
    draw_smg(img, PALETTE)
    # Void energy core + magenta sparks
    add_glow_effect(img, PALETTE, positions=[
        (12, 12), (14, 13), (16, 12), (18, 13), (20, 12)
    ])
    draw_rarity_border(img, "epic")
    save_frame(img, OUT_DIR, "weapon_void_sprayer")
    print("  ✓ void_sprayer complete")
