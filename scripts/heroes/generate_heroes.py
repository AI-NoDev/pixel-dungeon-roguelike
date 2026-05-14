"""Generate hero (player) pixel sprites for POP! Slime.

Produces 24x24 sprite sheets for each hero in 4 states:
- idle (4 frames - subtle breathing/idle bob)
- walk (4 frames - walking cycle)
- hurt (2 frames - white flash + recover)

Output: assets/images/heroes/<hero>_<state>.png
"""
from __future__ import annotations

import math
import os
import sys
from dataclasses import dataclass

from PIL import Image, ImageDraw

CANVAS = 24
OUT_DIR = os.path.join(
    os.path.dirname(__file__), "..", "..", "assets", "images", "heroes"
)


@dataclass(frozen=True)
class HeroPalette:
    skin: tuple
    skin_dark: tuple
    hair: tuple
    cloth_main: tuple   # primary armor/robe
    cloth_dark: tuple
    cloth_accent: tuple
    metal: tuple
    boots: tuple
    eye: tuple = (0, 0, 0, 255)


HEROES = {
    "knight": HeroPalette(
        skin=(255, 224, 189, 255),
        skin_dark=(212, 175, 145, 255),
        hair=(120, 80, 40, 255),
        cloth_main=(79, 195, 247, 255),    # cyan armor
        cloth_dark=(40, 130, 180, 255),
        cloth_accent=(255, 213, 79, 255),  # gold trim
        metal=(189, 189, 189, 255),
        boots=(80, 80, 80, 255),
    ),
    "ranger": HeroPalette(
        skin=(255, 224, 189, 255),
        skin_dark=(212, 175, 145, 255),
        hair=(40, 80, 30, 255),
        cloth_main=(102, 187, 106, 255),   # green tunic
        cloth_dark=(56, 142, 60, 255),
        cloth_accent=(141, 110, 99, 255),  # brown leather
        metal=(189, 165, 130, 255),
        boots=(60, 40, 20, 255),
    ),
    "mage": HeroPalette(
        skin=(245, 215, 195, 255),
        skin_dark=(195, 165, 145, 255),
        hair=(100, 60, 130, 255),
        cloth_main=(206, 147, 216, 255),   # purple robe
        cloth_dark=(123, 76, 140, 255),
        cloth_accent=(255, 235, 59, 255),  # yellow stars
        metal=(189, 189, 189, 255),
        boots=(60, 40, 80, 255),
    ),
    "rogue": HeroPalette(
        skin=(245, 215, 195, 255),
        skin_dark=(195, 165, 145, 255),
        hair=(50, 50, 50, 255),
        cloth_main=(255, 183, 77, 255),    # orange leather
        cloth_dark=(180, 110, 30, 255),
        cloth_accent=(50, 50, 50, 255),    # black hood
        metal=(189, 189, 189, 255),
        boots=(40, 30, 20, 255),
    ),
}


def new_canvas() -> Image.Image:
    return Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))


def draw_shadow(img: Image.Image, *, alpha: int = 90, width: int = 12, y: int = 22):
    d = ImageDraw.Draw(img)
    cx = CANVAS // 2
    d.ellipse([cx - width // 2, y, cx + width // 2, y + 2], fill=(0, 0, 0, alpha))


def draw_hero(
    img: Image.Image,
    p: HeroPalette,
    *,
    body_y: int = 12,    # top of body
    leg_offset_l: int = 0,
    leg_offset_r: int = 0,
    arm_offset: int = 0,
    head_bob: int = 0,
    hood: bool = False,
    hat: bool = False,
) -> None:
    """Draw a 24x24 hero. Top-down feet at the bottom.

    Layout (vertical):
      y=4-9: head (5px tall)
      y=9-11: hair/hood overlay
      y=11-19: body/torso (8px)
      y=19-23: legs (4px)
    """
    d = ImageDraw.Draw(img)
    cx = 12

    # ---- HEAD (5x6) at y=4-9 (with bob)
    head_top = 4 + head_bob
    head_bot = 9 + head_bob
    d.rectangle([cx - 3, head_top, cx + 2, head_bot], fill=p.skin)
    # Skin shading
    d.rectangle([cx - 3, head_bot, cx + 2, head_bot], fill=p.skin_dark)
    # Eyes
    d.point((cx - 2, head_top + 3), fill=p.eye)
    d.point((cx + 1, head_top + 3), fill=p.eye)
    # Mouth tiny
    d.point((cx, head_top + 5), fill=p.skin_dark)

    # ---- HAIR / HOOD
    if hood:
        # Rogue hood
        d.rectangle([cx - 4, head_top - 1, cx + 3, head_top + 2], fill=p.cloth_accent)
        d.rectangle([cx - 4, head_top + 2, cx - 3, head_top + 4], fill=p.cloth_accent)
        d.rectangle([cx + 2, head_top + 2, cx + 3, head_top + 4], fill=p.cloth_accent)
    elif hat:
        # Wizard pointy hat
        d.rectangle([cx - 4, head_top + 1, cx + 3, head_top + 2], fill=p.cloth_main)
        d.rectangle([cx - 3, head_top - 1, cx + 2, head_top + 1], fill=p.cloth_main)
        d.rectangle([cx - 1, head_top - 3, cx, head_top - 1], fill=p.cloth_main)
        d.point((cx - 1, head_top - 4), fill=p.cloth_accent)
    else:
        # Regular hair (knight + ranger)
        d.rectangle([cx - 3, head_top - 1, cx + 2, head_top + 1], fill=p.hair)
        d.rectangle([cx - 4, head_top + 1, cx - 3, head_top + 3], fill=p.hair)
        d.rectangle([cx + 2, head_top + 1, cx + 3, head_top + 3], fill=p.hair)

    # ---- TORSO at y=body_y..body_y+7
    ty = body_y
    d.rectangle([cx - 4, ty, cx + 3, ty + 6], fill=p.cloth_main)
    # Vertical center seam
    d.line([cx, ty, cx, ty + 6], fill=p.cloth_dark)
    # Belt
    d.rectangle([cx - 4, ty + 6, cx + 3, ty + 7], fill=p.cloth_dark)
    # Accent (chest emblem)
    d.point((cx - 1, ty + 2), fill=p.cloth_accent)
    d.point((cx, ty + 2), fill=p.cloth_accent)

    # ---- ARMS (one on each side)
    arm_y = ty + 1 + arm_offset
    d.rectangle([cx - 5, arm_y, cx - 5, arm_y + 4], fill=p.cloth_main)
    d.rectangle([cx + 4, arm_y, cx + 4, arm_y + 4], fill=p.cloth_main)
    # Hands
    d.point((cx - 5, arm_y + 4), fill=p.skin)
    d.point((cx + 4, arm_y + 4), fill=p.skin)

    # ---- LEGS at y=ty+7..ty+11
    ly = ty + 7
    # Left leg
    d.rectangle([cx - 3, ly, cx - 2, ly + 3 + leg_offset_l], fill=p.cloth_dark)
    # Right leg
    d.rectangle([cx + 1, ly, cx + 2, ly + 3 + leg_offset_r], fill=p.cloth_dark)
    # Boots
    d.rectangle([cx - 3, ly + 3 + leg_offset_l, cx - 2, ly + 3 + leg_offset_l],
                fill=p.boots)
    d.rectangle([cx + 1, ly + 3 + leg_offset_r, cx + 2, ly + 3 + leg_offset_r],
                fill=p.boots)


def gen_idle(name: str, p: HeroPalette, *, hood: bool, hat: bool):
    frames = []
    for i in range(4):
        bob = -1 if i == 1 else 1 if i == 3 else 0
        img = new_canvas()
        draw_shadow(img)
        draw_hero(img, p, head_bob=bob, hood=hood, hat=hat)
        frames.append(img)
    save_sheet(frames, f"hero_{name}_idle")


def gen_walk(name: str, p: HeroPalette, *, hood: bool, hat: bool):
    frames = []
    for i in range(4):
        # 4-frame walk: leg swap + slight bob
        if i == 0:
            lo_l, lo_r, ao = 0, 0, 0
            bob = 0
        elif i == 1:
            lo_l, lo_r, ao = -1, 1, -1
            bob = -1
        elif i == 2:
            lo_l, lo_r, ao = 0, 0, 0
            bob = 0
        else:
            lo_l, lo_r, ao = 1, -1, 1
            bob = -1
        img = new_canvas()
        draw_shadow(img, alpha=90 - abs(bob) * 20)
        draw_hero(img, p, leg_offset_l=lo_l, leg_offset_r=lo_r,
                  arm_offset=ao, head_bob=bob, hood=hood, hat=hat)
        frames.append(img)
    save_sheet(frames, f"hero_{name}_walk")


def gen_hurt(name: str, p: HeroPalette, *, hood: bool, hat: bool):
    # 2 frames: white flash, then normal-but-shaken
    frames = []
    white = HeroPalette(
        skin=(255, 255, 255, 255),
        skin_dark=(220, 220, 220, 255),
        hair=(255, 255, 255, 255),
        cloth_main=(255, 255, 255, 255),
        cloth_dark=(220, 220, 220, 255),
        cloth_accent=(255, 255, 255, 255),
        metal=(255, 255, 255, 255),
        boots=(220, 220, 220, 255),
        eye=(0, 0, 0, 255),
    )
    img0 = new_canvas()
    draw_shadow(img0)
    draw_hero(img0, white, hood=hood, hat=hat)
    frames.append(img0)
    img1 = new_canvas()
    draw_shadow(img1)
    draw_hero(img1, p, hood=hood, hat=hat, head_bob=1)
    frames.append(img1)
    save_sheet(frames, f"hero_{name}_hurt")


def save_sheet(frames: list[Image.Image], name: str):
    os.makedirs(OUT_DIR, exist_ok=True)
    if not frames:
        return
    sheet = Image.new("RGBA", (CANVAS * len(frames), CANVAS), (0, 0, 0, 0))
    for i, f in enumerate(frames):
        sheet.paste(f, (i * CANVAS, 0))
    out = os.path.join(OUT_DIR, f"{name}.png")
    sheet.save(out)
    print(f"  -> {out} ({len(frames)} frames)")


def main():
    print("Generating hero sprites...")
    for name, p in HEROES.items():
        hood = (name == "rogue")
        hat = (name == "mage")
        gen_idle(name, p, hood=hood, hat=hat)
        gen_walk(name, p, hood=hood, hat=hat)
        gen_hurt(name, p, hood=hood, hat=hat)
        print(f"  ✓ {name} complete")
    print("Done.")


if __name__ == "__main__":
    sys.exit(main() or 0)
