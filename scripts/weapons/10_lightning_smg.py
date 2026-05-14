#!/usr/bin/env python3
"""Lightning SMG — electric SMG (Rare)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_smg, draw_rarity_border,
    add_glow_effect, save_frame,
)

PALETTE = WeaponPalette.from_hex(
    main="#7C4DFF",          # purple metal
    highlight="#B388FF",
    shadow="#311B92",
    accent="#FFEB3B",
    glow="#FFFFFF",          # white spark
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/weapons",
)


if __name__ == "__main__":
    print("Generating: lightning_smg")
    img = new_canvas(24)
    draw_smg(img, PALETTE)
    # Electric coils
    add_glow_effect(img, PALETTE, positions=[
        (16, 11), (18, 12), (20, 11), (10, 11)
    ])
    draw_rarity_border(img, "rare")
    save_frame(img, OUT_DIR, "weapon_lightning_smg")
    print("  ✓ lightning_smg complete")
