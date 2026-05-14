#!/usr/bin/env python3
"""Plasma Beam — cyan plasma laser (Rare)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (WeaponPalette, new_canvas, draw_rarity_border, save_frame)
from _extra_shapes import draw_laser

PALETTE = WeaponPalette.from_hex(
    main="#1E88E5",
    highlight="#80DEEA",
    shadow="#0D47A1",
    accent="#00E5FF",
    glow="#FFFFFF",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: plasma_beam")
    img = new_canvas(24)
    draw_laser(img, PALETTE)
    draw_rarity_border(img, "rare")
    save_frame(img, OUT_DIR, "weapon_plasma_beam")
    print("  ✓ plasma_beam complete")
