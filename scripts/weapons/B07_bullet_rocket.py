#!/usr/bin/env python3
"""Rocket bullet — small rocket with fire trail (4 frames)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import WeaponPalette, new_canvas, save_spritesheet
from PIL import ImageDraw

PALETTE = WeaponPalette.from_hex(
    main="#BF360C",
    highlight="#FFEB3B",
    shadow="#7F0000",
    glow="#FF6F00",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/bullets",
)


def draw_rocket_bullet(img, frame):
    draw = ImageDraw.Draw(img)
    cx, cy = img.width // 2, img.height // 2
    # Rocket body (pointing right)
    draw.rectangle([cx - 1, cy - 1, cx + 2, cy + 1], fill=PALETTE.main)
    draw.point((cx + 2, cy), fill=PALETTE.highlight)  # warhead
    # Fins
    draw.point((cx - 1, cy - 1), fill=PALETTE.shadow)
    draw.point((cx - 1, cy + 1), fill=PALETTE.shadow)
    # Fire trail (animated)
    trail_offsets = [
        [(-3, 0), (-4, -1), (-4, 1)],
        [(-3, 0), (-4, 0), (-5, -1)],
        [(-3, 0), (-4, 1), (-5, 0)],
        [(-3, 0), (-4, -1), (-5, 1)],
    ]
    for dx, dy in trail_offsets[frame % len(trail_offsets)]:
        x = cx + dx
        y = cy + dy
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=PALETTE.glow)


if __name__ == "__main__":
    print("Generating: bullet_rocket")
    frames = []
    for i in range(4):
        img = new_canvas(8)
        draw_rocket_bullet(img, i)
        frames.append(img)
    save_spritesheet(frames, OUT_DIR, "bullet_rocket")
    print("  ✓ bullet_rocket complete")
