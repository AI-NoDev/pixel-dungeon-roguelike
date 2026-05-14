#!/usr/bin/env python3
"""Lightning Bullet — yellow electric bolt (4 frames)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import (
    WeaponPalette, new_canvas, draw_bullet_elemental, save_spritesheet,
)

PALETTE = WeaponPalette.from_hex(
    main="#FFEB3B",
    highlight="#FFFFFF",
    shadow="#F57F17",
    glow="#82B1FF",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/bullets",
)


if __name__ == "__main__":
    print("Generating: bullet_lightning")
    frames = []
    for i in range(4):
        img = new_canvas(8)
        draw_bullet_elemental(img, PALETTE, radius=2, frame=i)
        frames.append(img)
    save_spritesheet(frames, OUT_DIR, "bullet_lightning")
    print("  ✓ bullet_lightning complete")
