#!/usr/bin/env python3
"""Enemy Bullet — red basic enemy projectile."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_bullet_basic, save_spritesheet,
)

PALETTE = WeaponPalette.from_hex(
    main="#EF5350",
    highlight="#FFCDD2",
    shadow="#B71C1C",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/bullets",
)


if __name__ == "__main__":
    print("Generating: bullet_enemy")
    img = new_canvas(8)
    draw_bullet_basic(img, PALETTE, radius=2)
    save_spritesheet([img], OUT_DIR, "bullet_enemy")
    print("  ✓ bullet_enemy complete")
