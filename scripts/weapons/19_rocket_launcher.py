#!/usr/bin/env python3
"""Rocket Launcher — military rocket launcher (Rare)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (WeaponPalette, new_canvas, draw_rarity_border, save_frame)
from _extra_shapes import draw_rocket

PALETTE = WeaponPalette.from_hex(
    main="#558B2F",
    highlight="#9CCC65",
    shadow="#33691E",
    accent="#BF360C",
    glow="#FF6F00",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: rocket_launcher")
    img = new_canvas(24)
    draw_rocket(img, PALETTE)
    draw_rarity_border(img, "rare")
    save_frame(img, OUT_DIR, "weapon_rocket_launcher")
    print("  ✓ rocket_launcher complete")
