"""Pixel art utilities for weapon and bullet generation."""
from __future__ import annotations

import math
import os
from dataclasses import dataclass

from PIL import Image, ImageDraw


@dataclass(frozen=True)
class WeaponPalette:
    """Color palette for a weapon."""
    main: tuple[int, int, int, int]
    highlight: tuple[int, int, int, int]
    shadow: tuple[int, int, int, int]
    accent: tuple[int, int, int, int] | None = None
    glow: tuple[int, int, int, int] | None = None
    rarity: tuple[int, int, int, int] | None = None

    @staticmethod
    def from_hex(main: str, highlight: str, shadow: str,
                 accent: str | None = None,
                 glow: str | None = None,
                 rarity: str | None = None) -> "WeaponPalette":
        return WeaponPalette(
            main=hex_to_rgba(main),
            highlight=hex_to_rgba(highlight),
            shadow=hex_to_rgba(shadow),
            accent=hex_to_rgba(accent) if accent else None,
            glow=hex_to_rgba(glow) if glow else None,
            rarity=hex_to_rgba(rarity) if rarity else None,
        )


def hex_to_rgba(hex_str: str, alpha: int = 255) -> tuple[int, int, int, int]:
    s = hex_str.lstrip("#")
    return (
        int(s[0:2], 16),
        int(s[2:4], 16),
        int(s[4:6], 16),
        alpha,
    )


# Rarity border colors
RARITY_BORDERS = {
    "common": "#BDBDBD",
    "uncommon": "#66BB6A",
    "rare": "#42A5F5",
    "epic": "#AB47BC",
    "legendary": "#FFD54F",
}


def new_canvas(size: int = 24) -> Image.Image:
    """Create a new transparent canvas."""
    return Image.new("RGBA", (size, size), (0, 0, 0, 0))


def save_frame(img: Image.Image, out_dir: str, name: str) -> None:
    """Save a frame to the assets directory."""
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, f"{name}.png")
    img.save(out_path)
    print(f"  → {out_path}")


def save_spritesheet(frames: list[Image.Image], out_dir: str, name: str) -> None:
    """Combine frames horizontally into a sprite sheet."""
    if not frames:
        return
    w = frames[0].width
    h = frames[0].height
    sheet = Image.new("RGBA", (w * len(frames), h), (0, 0, 0, 0))
    for i, frame in enumerate(frames):
        sheet.paste(frame, (w * i, 0))
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, f"{name}.png")
    sheet.save(out_path)
    print(f"  → {out_path} ({len(frames)} frames)")


# ---------------------------------------------------------------------------
# Weapon icon helpers
# ---------------------------------------------------------------------------

def draw_rarity_border(img: Image.Image, rarity: str = "common") -> None:
    """Draw a colored rarity border around the icon."""
    if rarity not in RARITY_BORDERS:
        return
    border_color = hex_to_rgba(RARITY_BORDERS[rarity])
    draw = ImageDraw.Draw(img)
    w, h = img.size
    # Thin border
    draw.rectangle([0, 0, w - 1, h - 1], outline=border_color, width=1)


def draw_pistol(
    img: Image.Image,
    palette: WeaponPalette,
    *,
    barrel_color=None,
    grip_color=None,
) -> None:
    """Draw a pistol shape pointing right."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Frame body
    draw.rectangle([cx - 6, cy - 1, cx + 4, cy + 3], fill=palette.main)
    # Highlight
    draw.rectangle([cx - 6, cy - 1, cx + 4, cy], fill=palette.highlight)
    # Shadow
    draw.rectangle([cx - 6, cy + 3, cx + 4, cy + 3], fill=palette.shadow)
    # Barrel
    draw.rectangle([cx + 4, cy, cx + 8, cy + 1], fill=barrel_color or palette.main)
    # Grip
    grip = grip_color or palette.shadow
    draw.rectangle([cx - 6, cy + 3, cx - 4, cy + 7], fill=grip)
    # Trigger guard
    draw.rectangle([cx - 4, cy + 3, cx - 2, cy + 5], fill=palette.shadow)


def draw_shotgun(
    img: Image.Image,
    palette: WeaponPalette,
) -> None:
    """Draw a shotgun shape pointing right."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Wood stock (left)
    stock_color = palette.shadow
    draw.rectangle([cx - 9, cy - 1, cx - 4, cy + 3], fill=stock_color)
    # Barrels (double, right side)
    draw.rectangle([cx - 4, cy - 2, cx + 9, cy + 1], fill=palette.main)
    draw.rectangle([cx - 4, cy - 1, cx + 9, cy], fill=palette.highlight)
    # Lower barrel
    draw.rectangle([cx - 4, cy + 1, cx + 9, cy + 2], fill=palette.shadow)
    # Trigger area
    draw.rectangle([cx - 4, cy + 3, cx, cy + 4], fill=palette.shadow)


def draw_rifle(
    img: Image.Image,
    palette: WeaponPalette,
) -> None:
    """Draw a rifle (long, with scope)."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Long barrel
    draw.rectangle([cx - 8, cy, cx + 9, cy + 2], fill=palette.main)
    draw.rectangle([cx - 8, cy, cx + 9, cy], fill=palette.highlight)
    draw.rectangle([cx - 8, cy + 2, cx + 9, cy + 2], fill=palette.shadow)
    # Wood stock
    draw.rectangle([cx - 10, cy + 1, cx - 7, cy + 4], fill=(93, 64, 55, 255))
    # Scope on top
    draw.rectangle([cx - 2, cy - 2, cx + 2, cy - 1], fill=palette.shadow)


def draw_smg(
    img: Image.Image,
    palette: WeaponPalette,
) -> None:
    """Draw an SMG (compact with magazine)."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Body
    draw.rectangle([cx - 5, cy - 1, cx + 4, cy + 3], fill=palette.main)
    draw.rectangle([cx - 5, cy - 1, cx + 4, cy], fill=palette.highlight)
    # Short barrel
    draw.rectangle([cx + 4, cy, cx + 8, cy + 1], fill=palette.shadow)
    # Magazine (drum)
    draw.rectangle([cx - 2, cy + 3, cx + 1, cy + 7], fill=palette.shadow)
    # Stock
    draw.rectangle([cx - 7, cy, cx - 5, cy + 3], fill=palette.shadow)


def draw_sniper_bow(
    img: Image.Image,
    palette: WeaponPalette,
) -> None:
    """Draw a longbow shape."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Bow frame (curved, drawn as multiple segments)
    bow_color = palette.main
    # Left curve
    points = [
        (cx - 6, cy - 6),
        (cx - 8, cy - 3),
        (cx - 8, cy + 3),
        (cx - 6, cy + 6),
    ]
    for px, py in points:
        draw.point((px, py), fill=bow_color)
    # Connect with lines
    draw.line([cx - 8, cy - 3, cx - 8, cy + 3], fill=bow_color)
    # Right side
    points2 = [
        (cx + 6, cy - 6),
        (cx + 8, cy - 3),
        (cx + 8, cy + 3),
        (cx + 6, cy + 6),
    ]
    for px, py in points2:
        draw.point((px, py), fill=bow_color)
    draw.line([cx + 8, cy - 3, cx + 8, cy + 3], fill=bow_color)
    # Top and bottom curves
    draw.line([cx - 6, cy - 6, cx + 6, cy - 6], fill=bow_color)
    draw.line([cx - 6, cy + 6, cx + 6, cy + 6], fill=bow_color)
    # Bowstring
    draw.line([cx - 7, cy - 3, cx - 7, cy + 3], fill=palette.highlight)
    draw.line([cx + 7, cy - 3, cx + 7, cy + 3], fill=palette.highlight)
    # Arrow nocked
    draw.line([cx - 1, cy, cx + 6, cy], fill=palette.shadow)
    draw.point((cx + 6, cy), fill=palette.shadow)


def draw_staff(
    img: Image.Image,
    palette: WeaponPalette,
) -> None:
    """Draw a magic staff with crystal."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Staff handle (vertical)
    handle_color = (93, 64, 55, 255)  # brown wood
    draw.rectangle([cx - 1, cy - 4, cx + 1, cy + 8], fill=handle_color)
    draw.rectangle([cx - 1, cy - 4, cx, cy + 8], fill=palette.highlight)
    # Crystal on top (diamond shape)
    draw.rectangle([cx - 2, cy - 7, cx + 2, cy - 3], fill=palette.main)
    # Crystal highlight
    draw.point((cx - 1, cy - 6), fill=palette.highlight)
    draw.point((cx, cy - 7), fill=palette.highlight)
    # Crystal facets
    draw.point((cx + 1, cy - 5), fill=palette.shadow)
    # Glow effect
    if palette.glow:
        for px, py in [(cx - 3, cy - 5), (cx + 3, cy - 5), (cx, cy - 8)]:
            if 0 <= px < w and 0 <= py < h:
                draw.point((px, py), fill=palette.glow)


def add_glow_effect(
    img: Image.Image,
    palette: WeaponPalette,
    *,
    positions: list[tuple[int, int]],
) -> None:
    """Add small glow particles at specific positions."""
    if not palette.glow:
        return
    draw = ImageDraw.Draw(img)
    for x, y in positions:
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.glow)


# ---------------------------------------------------------------------------
# Bullet drawing helpers
# ---------------------------------------------------------------------------

def draw_bullet_basic(
    img: Image.Image,
    palette: WeaponPalette,
    *,
    radius: int = 2,
) -> None:
    """Draw a basic round bullet."""
    draw = ImageDraw.Draw(img)
    cx, cy = img.width // 2, img.height // 2
    # Outer
    draw.ellipse([cx - radius, cy - radius, cx + radius, cy + radius],
                 fill=palette.main)
    # Highlight
    draw.point((cx - 1, cy - 1), fill=palette.highlight)


def draw_bullet_elemental(
    img: Image.Image,
    palette: WeaponPalette,
    *,
    radius: int = 3,
    frame: int = 0,
) -> None:
    """Draw an elemental bullet with glow particles."""
    draw = ImageDraw.Draw(img)
    cx, cy = img.width // 2, img.height // 2
    # Glow halo
    if palette.glow:
        draw.ellipse([cx - radius - 1, cy - radius - 1,
                      cx + radius + 1, cy + radius + 1],
                     fill=palette.glow)
    # Core
    draw.ellipse([cx - radius, cy - radius, cx + radius, cy + radius],
                 fill=palette.main)
    # Highlight
    draw.point((cx - 1, cy - 1), fill=palette.highlight)
    # Trailing particles (animate)
    trail_offsets = [
        [(-3, -1), (-4, 1)],
        [(-3, 1), (-4, -1)],
        [(-2, -2), (-4, 0)],
        [(-2, 2), (-4, 0)],
    ]
    for dx, dy in trail_offsets[frame % len(trail_offsets)]:
        x = cx + dx
        y = cy + dy
        if 0 <= x < img.width and 0 <= y < img.height:
            draw.point((x, y), fill=palette.highlight)
