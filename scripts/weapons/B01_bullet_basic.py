#!/usr/bin/env python3
"""Basic Bullet — simple yellow bullet (no element)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_bullet_basic, save_spritesheet,
)

PALETTE = WeaponPalette.from_hex(
    main="#FFD54F",
    highlight="#FFFFFF",
    shadow="#FF8F00",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/bullets",
)


if __name__ == "__main__":
    print("Generating: bullet_basic")
    # Single frame, simple round bullet
    img = new_canvas(8)
    draw_bullet_basic(img, PALETTE, radius=2)
    save_spritesheet([img], OUT_DIR, "bullet_basic")
    print("  ✓ bullet_basic complete")
