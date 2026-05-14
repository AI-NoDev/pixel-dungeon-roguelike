#!/usr/bin/env python3
"""Frost Revolver — ice element revolver (Rare)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_pistol, draw_rarity_border,
    add_glow_effect, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#90CAF9",         # icy blue metal
    highlight="#E1F5FE",
    shadow="#01579B",
    accent="#4FC3F7",
    glow="#80DEEA",          # cyan glow
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: frost_revolver")
    img = new_canvas(24)
    draw_pistol(img, PALETTE)
    # Frost crystals on barrel
    add_glow_effect(img, PALETTE, positions=[(20, 11), (21, 12), (18, 11), (22, 12)])
    draw_rarity_border(img, "rare")
    save_frame(img, OUT_DIR, "weapon_frost_revolver")
    print("  ✓ frost_revolver complete")
