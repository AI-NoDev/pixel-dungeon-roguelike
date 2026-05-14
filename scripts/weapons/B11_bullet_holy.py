#!/usr/bin/env python3
"""Holy bullet — golden divine projectile (4 frames pulsing)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import WeaponPalette, new_canvas, draw_bullet_elemental, save_spritesheet

PALETTE = WeaponPalette.from_hex(
    main="#FFD700",
    highlight="#FFFFFF",
    shadow="#FF8F00",
    glow="#FFEB3B",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/bullets",
)


if __name__ == "__main__":
    print("Generating: bullet_holy")
    frames = []
    for i in range(4):
        img = new_canvas(8)
        draw_bullet_elemental(img, PALETTE, radius=3, frame=i)
        frames.append(img)
    save_spritesheet(frames, OUT_DIR, "bullet_holy")
    print("  ✓ bullet_holy complete")
