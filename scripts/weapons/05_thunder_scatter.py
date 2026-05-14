#!/usr/bin/env python3
"""Thunder Scatter — electric shotgun (Rare)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_shotgun, draw_rarity_border,
    add_glow_effect, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#FFCA28",       # yellow electric
    highlight="#FFF59D",
    shadow="#F57F17",
    accent="#1A1A2E",
    glow="#82B1FF",       # blue arcs
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: thunder_scatter")
    img = new_canvas(24)
    draw_shotgun(img, PALETTE)
    # Electric arcs
    add_glow_effect(img, PALETTE, positions=[
        (15, 9), (17, 10), (19, 9), (21, 11), (16, 14)
    ])
    draw_rarity_border(img, "rare")
    save_frame(img, OUT_DIR, "weapon_thunder_scatter")
    print("  ✓ thunder_scatter complete")
