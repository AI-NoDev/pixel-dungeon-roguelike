#!/usr/bin/env python3
"""Laser bullet — bright beam segment (4 frames pulsing)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import WeaponPalette, new_canvas, save_spritesheet
from PIL import ImageDraw

PALETTE = WeaponPalette.from_hex(
    main="#FF1744",
    highlight="#FFFFFF",
    shadow="#7F0000",
    glow="#FFCDD2",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/bullets",
)


def draw_laser_bullet(img, frame):
    draw = ImageDraw.Draw(img)
    cx, cy = img.width // 2, img.height // 2
    # Bright core line (horizontal)
    pulse = 1 if frame % 2 == 0 else 0
    draw.line([cx - 3, cy, cx + 3, cy], fill=PALETTE.highlight)
    draw.line([cx - 3, cy + pulse, cx + 3, cy + pulse], fill=PALETTE.main)
    # Outer glow
    draw.point((cx - 4, cy), fill=PALETTE.glow)
    draw.point((cx + 4, cy), fill=PALETTE.glow)


if __name__ == "__main__":
    print("Generating: bullet_laser")
    frames = []
    for i in range(4):
        img = new_canvas(8)
        draw_laser_bullet(img, i)
        frames.append(img)
    save_spritesheet(frames, OUT_DIR, "bullet_laser")
    print("  ✓ bullet_laser complete")
