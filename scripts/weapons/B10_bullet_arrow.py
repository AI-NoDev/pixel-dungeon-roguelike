#!/usr/bin/env python3
"""Arrow bullet — wooden arrow (single frame, rotates via Flame)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import WeaponPalette, new_canvas, save_spritesheet
from PIL import ImageDraw

PALETTE = WeaponPalette.from_hex(
    main="#8D6E63",
    highlight="#A1887F",
    shadow="#3E2723",
)

OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/bullets",
)


def draw_arrow_bullet(img):
    draw = ImageDraw.Draw(img)
    cx, cy = img.width // 2, img.height // 2
    # Shaft
    draw.line([cx - 3, cy, cx + 2, cy], fill=PALETTE.main)
    # Head (sharp tip)
    draw.point((cx + 3, cy), fill=PALETTE.highlight)
    # Fletching at back
    draw.point((cx - 3, cy - 1), fill=PALETTE.shadow)
    draw.point((cx - 3, cy + 1), fill=PALETTE.shadow)


if __name__ == "__main__":
    print("Generating: bullet_arrow")
    img = new_canvas(8)
    draw_arrow_bullet(img)
    save_spritesheet([img], OUT_DIR, "bullet_arrow")
    print("  ✓ bullet_arrow complete")
