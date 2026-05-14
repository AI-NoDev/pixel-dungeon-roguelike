"""Generate dungeon decoration sprites for POP! Slime.

Each decoration is a 24x24 pixel art tile placed randomly in rooms by
DungeonWorld. They are non-blocking (no hitbox) — purely visual.

Outputs into assets/images/decor/
"""
from __future__ import annotations

import math
import os
import random

from PIL import Image, ImageDraw

CANVAS = 24
OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "assets", "images", "decor")


def new_canvas() -> Image.Image:
    return Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))


def hex_to_rgba(hex_str: str, alpha: int = 255) -> tuple:
    s = hex_str.lstrip("#")
    return (int(s[0:2], 16), int(s[2:4], 16), int(s[4:6], 16), alpha)


def save(img: Image.Image, name: str) -> None:
    os.makedirs(OUT_DIR, exist_ok=True)
    out = os.path.join(OUT_DIR, f"{name}.png")
    img.save(out)
    print(f"  -> {out}")


# ---------------------------------------------------------------------------
# Decor pieces
# ---------------------------------------------------------------------------

def torch():
    """Wall torch with flame."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    # Wall mount
    d.rectangle([10, 16, 13, 22], fill=hex_to_rgba("#5D4037"))
    d.rectangle([8, 14, 15, 17], fill=hex_to_rgba("#3E2723"))
    # Flame
    d.ellipse([9, 6, 14, 14], fill=hex_to_rgba("#FF6F00"))
    d.ellipse([10, 4, 13, 11], fill=hex_to_rgba("#FFEB3B"))
    d.point((11, 3), fill=hex_to_rgba("#FFEB3B"))
    return img


def torch_lit_alt():
    """Slightly different flame frame for animation."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    d.rectangle([10, 16, 13, 22], fill=hex_to_rgba("#5D4037"))
    d.rectangle([8, 14, 15, 17], fill=hex_to_rgba("#3E2723"))
    d.ellipse([9, 7, 14, 14], fill=hex_to_rgba("#FF8F00"))
    d.ellipse([10, 5, 13, 12], fill=hex_to_rgba("#FFE082"))
    return img


def barrel():
    """Wooden barrel."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    body = hex_to_rgba("#8D6E63")
    dark = hex_to_rgba("#5D4037")
    band = hex_to_rgba("#3E2723")
    d.ellipse([4, 4, 19, 8], fill=body)
    d.rectangle([4, 6, 19, 19], fill=body)
    d.ellipse([4, 17, 19, 21], fill=body)
    # Highlights
    d.line([(6, 8), (6, 19)], fill=hex_to_rgba("#A1887F"))
    # Bands
    d.rectangle([4, 9, 19, 10], fill=band)
    d.rectangle([4, 16, 19, 17], fill=band)
    return img


def crate():
    """Wooden crate."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    body = hex_to_rgba("#A1887F")
    edge = hex_to_rgba("#5D4037")
    d.rectangle([3, 5, 20, 21], fill=body)
    d.rectangle([3, 5, 20, 21], outline=edge, width=1)
    d.line([(3, 5), (20, 21)], fill=edge)
    d.line([(20, 5), (3, 21)], fill=edge)
    return img


def skull():
    """Floor skull."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    bone = hex_to_rgba("#EEEEEE")
    dark = hex_to_rgba("#9E9E9E")
    d.ellipse([6, 8, 17, 19], fill=bone)
    d.rectangle([8, 16, 15, 20], fill=bone)
    # Eye sockets
    d.rectangle([8, 12, 10, 14], fill=hex_to_rgba("#212121"))
    d.rectangle([13, 12, 15, 14], fill=hex_to_rgba("#212121"))
    # Teeth
    d.line([(9, 18), (14, 18)], fill=dark)
    d.line([(11, 17), (11, 19)], fill=dark)
    return img


def bones():
    """Pile of bones."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    bone = hex_to_rgba("#EEEEEE")
    # Two crossing bones
    d.line([(4, 18), (19, 8)], fill=bone, width=2)
    d.line([(4, 8), (19, 18)], fill=bone, width=2)
    d.ellipse([3, 6, 7, 10], fill=bone)
    d.ellipse([16, 16, 20, 20], fill=bone)
    d.ellipse([3, 16, 7, 20], fill=bone)
    d.ellipse([16, 6, 20, 10], fill=bone)
    return img


def crystal():
    """Glowing crystal."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    glow = hex_to_rgba("#80DEEA", 80)
    # Glow halo
    d.ellipse([3, 3, 20, 20], fill=glow)
    # Crystal shape
    d.polygon([(11, 4), (16, 12), (11, 20), (7, 12)],
              fill=hex_to_rgba("#4DD0E1"))
    d.polygon([(11, 4), (13, 12), (11, 20)],
              fill=hex_to_rgba("#B2EBF2"))
    return img


def mushroom():
    """Glowing mushroom."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    cap = hex_to_rgba("#7B1FA2")
    spots = hex_to_rgba("#E1BEE7")
    stem = hex_to_rgba("#EEEEEE")
    d.rectangle([10, 15, 13, 21], fill=stem)
    d.ellipse([5, 8, 18, 17], fill=cap)
    d.ellipse([8, 10, 11, 13], fill=spots)
    d.ellipse([13, 11, 16, 14], fill=spots)
    d.point((10, 14), fill=spots)
    return img


def cobweb():
    """Cobweb in corner."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    web = hex_to_rgba("#BDBDBD", 180)
    # Lines from corner (0,0)
    for ang in [0, 0.3, 0.6, 0.9, 1.2, 1.5]:
        x = int(20 * math.cos(ang))
        y = int(20 * math.sin(ang))
        d.line([(0, 0), (x, y)], fill=web)
    # Concentric arcs
    for r in [6, 12, 18]:
        for k in range(0, 9):
            ang = k * 0.2
            x1 = int(r * math.cos(ang))
            y1 = int(r * math.sin(ang))
            x2 = int(r * math.cos(ang + 0.1))
            y2 = int(r * math.sin(ang + 0.1))
            if x2 < CANVAS and y2 < CANVAS:
                d.line([(x1, y1), (x2, y2)], fill=web)
    return img


def banner():
    """Hanging cloth banner."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    cloth = hex_to_rgba("#C62828")
    trim = hex_to_rgba("#FFD700")
    pole = hex_to_rgba("#5D4037")
    d.rectangle([2, 3, 21, 5], fill=pole)
    d.rectangle([7, 5, 16, 19], fill=cloth)
    d.polygon([(7, 19), (11, 22), (16, 19)], fill=cloth)
    # Trim
    d.rectangle([7, 5, 16, 6], fill=trim)
    return img


def chain():
    """Hanging chain."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    chain = hex_to_rgba("#9E9E9E")
    for y in range(0, 22, 4):
        d.ellipse([10, y, 13, y + 4], outline=chain, width=1)
    return img


def crack_wall():
    """Crack on the floor (subtle)."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    crack = hex_to_rgba("#3E2723", 200)
    d.line([(2, 4), (8, 9), (5, 14), (12, 18), (20, 21)], fill=crack)
    d.line([(8, 9), (13, 6)], fill=crack)
    d.line([(12, 18), (10, 22)], fill=crack)
    return img


def floor_tile_dark():
    """Single darker stone tile to break up floor monotony."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    base = hex_to_rgba("#3E2723", 150)
    edge = hex_to_rgba("#5D4037", 200)
    d.rectangle([2, 2, 21, 21], fill=base)
    d.rectangle([2, 2, 21, 21], outline=edge, width=1)
    return img


def grate():
    """Floor grate."""
    img = new_canvas()
    d = ImageDraw.Draw(img)
    metal = hex_to_rgba("#616161")
    dark = hex_to_rgba("#212121")
    d.rectangle([3, 3, 20, 20], fill=dark)
    for x in range(5, 20, 3):
        d.line([(x, 3), (x, 20)], fill=metal)
    for y in range(5, 20, 3):
        d.line([(3, y), (20, y)], fill=metal)
    return img


def main():
    print("Generating decor sprites...")
    save(torch(), "torch_a")
    save(torch_lit_alt(), "torch_b")
    save(barrel(), "barrel")
    save(crate(), "crate")
    save(skull(), "skull")
    save(bones(), "bones")
    save(crystal(), "crystal")
    save(mushroom(), "mushroom")
    save(cobweb(), "cobweb")
    save(banner(), "banner")
    save(chain(), "chain")
    save(crack_wall(), "crack")
    save(floor_tile_dark(), "tile_dark")
    save(grate(), "grate")
    print("Done.")


if __name__ == "__main__":
    main()
