#!/usr/bin/env python3
"""Ancient Slime — translucent cyan with crystal heart and runes (60x60 hidden boss)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import SlimePalette, generate_all_animations
from PIL import ImageDraw

PALETTE = SlimePalette(
    main=(128, 222, 234, 160),     # 60% alpha
    highlight=(224, 247, 250, 220),
    shadow=(0, 131, 143, 220),
    eye=(255, 215, 0, 255),         # gold eye
    accent=(255, 82, 82, 255),      # red crystal heart
    extra=(255, 255, 255, 255),     # white runes
)


def add_ancient_features(img, palette, frame=0, **kwargs):
    """Add crystal heart, runes, and void rifts."""
    draw = ImageDraw.Draw(img)
    cx = img.width // 2
    cy = 30

    # Crystal heart (center, pulsing)
    heart_size = 4 if frame % 2 == 0 else 5
    draw.rectangle([cx - heart_size // 2, cy - heart_size // 2,
                    cx + heart_size // 2, cy + heart_size // 2],
                   fill=palette.accent)
    # Heart highlight
    draw.point((cx - 1, cy - 1), fill=(255, 255, 255, 255))

    # Runes scattered on body (white glowing)
    rune_positions = [
        [(15, 20), (40, 22), (20, 40), (38, 38)],
        [(18, 18), (42, 24), (22, 38), (36, 40)],
        [(15, 22), (40, 20), (20, 42), (38, 36)],
        [(18, 20), (42, 22), (22, 40), (36, 38)],
    ]
    for x, y in rune_positions[frame % len(rune_positions)]:
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.extra)
            # Small rune cross
            if 0 <= x - 1 < img.width:
                draw.point((x - 1, y), fill=palette.extra)
            if 0 <= x + 1 < img.width:
                draw.point((x + 1, y), fill=palette.extra)

    # Void rifts around body (dark purple zigzags)
    rift_color = (49, 27, 146, 200)
    rift_positions = [
        [(2, 28), (5, 30), (8, 32)],
        [(52, 30), (55, 32), (58, 34)],
    ]
    for points in rift_positions:
        for x, y in points:
            if 0 <= x < img.width and 0 <= y < img.height:
                draw.point((x, y), fill=rift_color)


OUT_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "../../assets/images/slimes",
)


if __name__ == "__main__":
    generate_all_animations(
        palette=PALETTE,
        out_dir=OUT_DIR,
        species_id="ancient",
        canvas_size=60,
        body_w=42,
        body_h=30,
        extra_decorate=add_ancient_features,
    )
