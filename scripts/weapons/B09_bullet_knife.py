#!/usr/bin/env python3
"""Knife bullet — spinning throwing knife (4 frames rotation)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import WeaponPalette, new_canvas, save_spritesheet
from PIL import ImageDraw

PALETTE = WeaponPalette.from_hex(
    main="#B0BEC5",
    highlight="#FFFFFF",
    shadow="#37474F",
    glow="#80DEEA",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/bullets",
)


def draw_knife_bullet(img, frame):
    draw = ImageDraw.Draw(img)
    cx, cy = img.width // 2, img.height // 2
    # 4 rotation frames (horizontal/diagonal/vertical/diagonal)
    if frame == 0:
        # Horizontal blade
        draw.line([cx - 3, cy, cx + 3, cy], fill=PALETTE.main)
        draw.point((cx + 3, cy), fill=PALETTE.highlight)
    elif frame == 1:
        # Diagonal /
        draw.line([cx - 3, cy + 2, cx + 3, cy - 2], fill=PALETTE.main)
        draw.point((cx + 3, cy - 2), fill=PALETTE.highlight)
    elif frame == 2:
        # Vertical
        draw.line([cx, cy - 3, cx, cy + 3], fill=PALETTE.main)
        draw.point((cx, cy - 3), fill=PALETTE.highlight)
    else:
        # Diagonal \
        draw.line([cx - 3, cy - 2, cx + 3, cy + 2], fill=PALETTE.main)
        draw.point((cx + 3, cy + 2), fill=PALETTE.highlight)


if __name__ == "__main__":
    print("Generating: bullet_knife")
    frames = []
    for i in range(4):
        img = new_canvas(8)
        draw_knife_bullet(img, i)
        frames.append(img)
    save_spritesheet(frames, OUT_DIR, "bullet_knife")
    print("  ✓ bullet_knife complete")
