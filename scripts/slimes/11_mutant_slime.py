#!/usr/bin/env python3
"""Mutant Slime — color-shifting chaotic slime with multiple eyes."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw


# Each frame = different color (representing mutation)
COLORS_PER_FRAME = [
    SlimePalette.from_hex("#66BB6A", "#A5D6A7", "#2E7D32"),  # green
    SlimePalette.from_hex("#FF5722", "#FFEB3B", "#BF360C"),  # red/fire
    SlimePalette.from_hex("#4FC3F7", "#E1F5FE", "#01579B"),  # blue/ice
    SlimePalette.from_hex("#FFEB3B", "#FFFFFF", "#FBC02D"),  # yellow/electric
]


def gen_mutant_animations(out_dir, species_id):
    """Custom generation — color shifts across frames."""
    from _pixel_lib import (
        new_canvas, draw_ground_shadow, draw_slime_body, draw_eyes,
        save_spritesheet,
    )

    # Idle: 4 frames, each with different color
    idle = []
    for i, palette in enumerate(COLORS_PER_FRAME):
        img = new_canvas(16)
        draw_ground_shadow(img)
        squash = 0.2 * (i % 2 - 0.5)  # alternate squash
        draw_slime_body(img, palette, width=12, height=8, squash=squash)
        # Multiple asymmetric eyes
        draw = ImageDraw.Draw(img)
        eye_positions = [
            [(5, 9), (10, 10), (8, 7)],
            [(6, 8), (11, 9), (7, 11)],
            [(5, 10), (10, 8), (8, 6)],
            [(6, 9), (11, 11), (7, 8)],
        ]
        for x, y in eye_positions[i]:
            draw.point((x, y), fill=palette.eye)
        idle.append(img)
    save_spritesheet(idle, out_dir, f"slime_{species_id}_idle")

    # Jump: same logic with cycling colors
    jump_offsets = [-0.4, 0.3, 0.1, -0.2]
    jump_y_offsets = [0, -2, -4, -1]
    jump = []
    for i in range(4):
        palette = COLORS_PER_FRAME[i]
        img = new_canvas(16)
        draw_ground_shadow(img, alpha=max(30, 80 + jump_y_offsets[i] * 10))
        cy = 10 + jump_y_offsets[i]
        draw_slime_body(img, palette, cy=cy, width=12, height=8, squash=jump_offsets[i])
        # Multi-eyes
        draw = ImageDraw.Draw(img)
        for x, y in [(5 + i, cy - 1), (10 - i, cy)]:
            draw.point((x, y), fill=palette.eye)
        jump.append(img)
    save_spritesheet(jump, out_dir, f"slime_{species_id}_jump")

    # Hurt: white flash + chaos
    hurt = []
    img0 = new_canvas(16)
    draw_ground_shadow(img0)
    white_pal = SlimePalette(
        main=(255, 255, 255, 255),
        highlight=(255, 255, 255, 255),
        shadow=(220, 220, 220, 255),
        eye=(255, 0, 0, 255),
    )
    draw_slime_body(img0, white_pal, width=12, height=8, squash=-0.1)
    draw_eyes(img0, white_pal, eye_y=10)
    hurt.append(img0)
    img1 = new_canvas(16)
    draw_ground_shadow(img1)
    draw_slime_body(img1, COLORS_PER_FRAME[0], width=12, height=8)
    draw_eyes(img1, COLORS_PER_FRAME[0], closed=True, eye_y=10)
    hurt.append(img1)
    save_spritesheet(hurt, out_dir, f"slime_{species_id}_hurt")

    # Death: cycles through all colors then dissolves
    import math
    death = []
    for i in range(6):
        progress = i / 5
        palette = COLORS_PER_FRAME[i % len(COLORS_PER_FRAME)]
        img = new_canvas(16)
        if progress < 0.9:
            draw_ground_shadow(img, alpha=int(80 * (1 - progress)))
            scale = 1 - progress * 0.7
            cw = max(2, int(12 * scale))
            ch = max(2, int(8 * scale))
            cy = 10 + int(progress * 4)
            faded = SlimePalette(
                main=(*palette.main[:3], int(255 * (1 - progress))),
                highlight=palette.highlight,
                shadow=palette.shadow,
                eye=palette.eye,
            )
            draw_slime_body(img, faded, cy=cy, width=cw, height=ch)
        # 5 colored droplets
        for j, col_pal in enumerate(COLORS_PER_FRAME):
            angle = 2 * math.pi * j / 5
            d = int(progress * 6)
            x = 8 + int(math.cos(angle) * d)
            y = 10 + int(math.sin(angle) * d)
            if 0 <= x < 16 and 0 <= y < 16:
                img.putpixel((x, y), (*col_pal.main[:3], int(200 * (1 - progress))))
        death.append(img)
    save_spritesheet(death, out_dir, f"slime_{species_id}_death")


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    print("Generating: mutant")
    gen_mutant_animations(OUT_DIR, "mutant")
    print("  ✓ mutant complete")
