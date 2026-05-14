#!/usr/bin/env python3
"""Dragon Breath — fire shotgun (Epic)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_shotgun, draw_rarity_border,
    add_glow_effect, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#D32F2F",      # ornate red
    highlight="#FF8A80",
    shadow="#7F0000",
    accent="#FFD700",     # gold trim
    glow="#FF6F00",       # fire breath
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: dragon_breath")
    img = new_canvas(24)
    draw_shotgun(img, PALETTE)
    # Fire breath particles
    add_glow_effect(img, PALETTE, positions=[
        (21, 9), (22, 10), (21, 11), (22, 12), (21, 13)
    ])
    draw_rarity_border(img, "epic")
    save_frame(img, OUT_DIR, "weapon_dragon_breath")
    print("  ✓ dragon_breath complete")
