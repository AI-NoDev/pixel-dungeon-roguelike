#!/usr/bin/env python3
"""Rainbow Slime — legendary 0.5% drop rate, prismatic body with stars."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw


# Rainbow body uses different colors per frame
RAINBOW_PALETTES = [
    SlimePalette.from_hex("#FF0000", "#FF8A80", "#B71C1C", eye="#FFD700"),
    SlimePalette.from_hex("#FF9100", "#FFCC80", "#E65100", eye="#FFD700"),
    SlimePalette.from_hex("#FFEB3B", "#FFF59D", "#F57F17", eye="#FFD700"),
    SlimePalette.from_hex("#4CAF50", "#A5D6A7", "#1B5E20", eye="#FFD700"),
    SlimePalette.from_hex("#2196F3", "#90CAF9", "#0D47A1", eye="#FFD700"),
    SlimePalette.from_hex("#9C27B0", "#CE93D8", "#4A148C", eye="#FFD700"),
]


def gen_rainbow_animations(out_dir, species_id):
    from _pixel_lib import (
        new_canvas, draw_ground_shadow, draw_slime_body, draw_eyes,
        save_spritesheet,
    )

    # Idle: 6 frames (one per rainbow color)
    idle = []
    for i, palette in enumerate(RAINBOW_PALETTES):
        img = new_canvas(16)
        draw_ground_shadow(img)
        squash = 0.15 * (i % 2 - 0.5)
        draw_slime_body(img, palette, width=12, height=8, squash=squash)
        draw_eyes(img, palette, eye_y=10)

        # Add star sparkles
        draw = ImageDraw.Draw(img)
        star_positions = [(2, 3), (13, 4), (4, 13), (12, 12), (1, 9)]
        for j, (x, y) in enumerate(star_positions):
            if (i + j) % 2 == 0 and 0 <= x < 16 and 0 <= y < 16:
                draw.point((x, y), fill=(255, 215, 0, 255))  # gold sparkle

        idle.append(img)
    save_spritesheet(idle, out_dir, f"slime_{species_id}_idle")

    # Jump: 4 frames cycling through colors
    jump = []
    jump_offsets = [-0.4, 0.3, 0.1, -0.2]
    jump_y_offsets = [0, -2, -4, -1]
    for i in range(4):
        palette = RAINBOW_PALETTES[i]
        img = new_canvas(16)
        draw_ground_shadow(img, alpha=max(30, 80 + jump_y_offsets[i] * 10))
        cy = 10 + jump_y_offsets[i]
        draw_slime_body(img, palette, cy=cy, width=12, height=8, squash=jump_offsets[i])
        draw_eyes(img, palette, eye_y=cy)
        # Trailing rainbow sparkles
        draw = ImageDraw.Draw(img)
        for x in [3, 12]:
            draw.point((x, cy + 2), fill=(255, 215, 0, 255))
        jump.append(img)
    save_spritesheet(jump, out_dir, f"slime_{species_id}_jump")

    # Hurt
    hurt = []
    img0 = new_canvas(16)
    draw_ground_shadow(img0)
    white_pal = SlimePalette(
        main=(255, 255, 255, 255), highlight=(255, 255, 255, 255),
        shadow=(220, 220, 220, 255), eye=(0, 0, 0, 255))
    draw_slime_body(img0, white_pal, width=12, height=8)
    draw_eyes(img0, white_pal, eye_y=10)
    hurt.append(img0)

    img1 = new_canvas(16)
    draw_ground_shadow(img1)
    draw_slime_body(img1, RAINBOW_PALETTES[0], width=12, height=8)
    draw_eyes(img1, RAINBOW_PALETTES[0], closed=True, eye_y=10)
    hurt.append(img1)
    save_spritesheet(hurt, out_dir, f"slime_{species_id}_hurt")

    # Death: explodes into rainbow gold burst
    import math
    death = []
    for i in range(8):
        progress = i / 7
        palette = RAINBOW_PALETTES[i % len(RAINBOW_PALETTES)]
        img = new_canvas(16)
        if progress < 0.7:
            draw_ground_shadow(img, alpha=int(80 * (1 - progress)))
            cy = 10
            scale = 1 - progress * 0.5
            cw = max(2, int(12 * scale))
            ch = max(2, int(8 * scale))
            draw_slime_body(img, palette, cy=cy, width=cw, height=ch)
        # Many sparkling stars exploding outward
        for j in range(8):
            angle = 2 * math.pi * j / 8 + i * 0.2
            d = int(progress * 8)
            x = 8 + int(math.cos(angle) * d)
            y = 10 + int(math.sin(angle) * d)
            if 0 <= x < 16 and 0 <= y < 16:
                star_color = RAINBOW_PALETTES[j % 6].main
                img.putpixel((x, y), (*star_color[:3], 255))
        death.append(img)
    save_spritesheet(death, out_dir, f"slime_{species_id}_death")


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    print("Generating: rainbow")
    gen_rainbow_animations(OUT_DIR, "rainbow")
    print("  ✓ rainbow complete")
