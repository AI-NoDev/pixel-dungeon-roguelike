#!/usr/bin/env python3
"""Poison Rifle — toxic green rifle (Uncommon)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_rifle, draw_rarity_border,
    add_glow_effect, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#558B2F",        # toxic green
    highlight="#9CCC65",
    shadow="#1B5E20",
    accent="#76FF03",
    glow="#76FF03",        # poison glow
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: poison_rifle")
    img = new_canvas(24)
    draw_rifle(img, PALETTE)
    # Toxic vials/glow on barrel
    add_glow_effect(img, PALETTE, positions=[
        (14, 10), (16, 11), (18, 10), (20, 11)
    ])
    draw_rarity_border(img, "uncommon")
    save_frame(img, OUT_DIR, "weapon_poison_rifle")
    print("  ✓ poison_rifle complete")
