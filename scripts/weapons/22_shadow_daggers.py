#!/usr/bin/env python3
"""Shadow Daggers — dark magic daggers (Rare)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (WeaponPalette, new_canvas, draw_rarity_border, save_frame)
from _extra_shapes import draw_knife

PALETTE = WeaponPalette.from_hex(
    main="#311B92",
    highlight="#9C27B0",
    shadow="#1A1A2E",
    accent="#7C4DFF",
    glow="#E040FB",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: shadow_daggers")
    img = new_canvas(24)
    draw_knife(img, PALETTE)
    draw_rarity_border(img, "rare")
    save_frame(img, OUT_DIR, "weapon_shadow_daggers")
    print("  ✓ shadow_daggers complete")
