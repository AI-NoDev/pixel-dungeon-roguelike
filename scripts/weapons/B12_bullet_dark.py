#!/usr/bin/env python3
"""Dark bullet — purple void projectile (4 frames pulsing)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import WeaponPalette, new_canvas, draw_bullet_elemental, save_spritesheet

PALETTE = WeaponPalette.from_hex(
    main="#7C4DFF",
    highlight="#E040FB",
    shadow="#311B92",
    glow="#1A1A2E",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/bullets",
)


if __name__ == "__main__":
    print("Generating: bullet_dark")
    frames = []
    for i in range(4):
        img = new_canvas(8)
        draw_bullet_elemental(img, PALETTE, radius=3, frame=i)
        frames.append(img)
    save_spritesheet(frames, OUT_DIR, "bullet_dark")
    print("  ✓ bullet_dark complete")
