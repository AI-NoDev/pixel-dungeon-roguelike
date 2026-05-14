#!/usr/bin/env python3
"""Ice Piercer — frozen ornate bow (Epic)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_sniper_bow, draw_rarity_border,
    add_glow_effect, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#00BCD4",          # cyan
    highlight="#80DEEA",
    shadow="#006064",
    accent="#E1F5FE",
    glow="#FFFFFF",          # white snowflakes
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: ice_piercer")
    img = new_canvas(24)
    draw_sniper_bow(img, PALETTE)
    # Snowflakes around bow
    add_glow_effect(img, PALETTE, positions=[
        (4, 8), (6, 14), (18, 8), (20, 14), (12, 4), (12, 18)
    ])
    draw_rarity_border(img, "epic")
    save_frame(img, OUT_DIR, "weapon_ice_piercer")
    print("  ✓ ice_piercer complete")
