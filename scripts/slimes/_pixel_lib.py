"""Pixel art utilities for slime generation.

Common helpers used by all slime scripts:
- Pixel-perfect drawing (no anti-aliasing)
- Slime body shape generator
- Animation frame export
- Color palette tools
"""
from __future__ import annotations

import math
import os
from dataclasses import dataclass
from typing import Iterable

from PIL import Image, ImageDraw


# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

# Display scale for output PNGs (game uses 16x16 source rendered at 32x32)
EXPORT_SCALE = 1  # keep at 1 to preserve pixel-perfect art


@dataclass(frozen=True)
class SlimePalette:
    """Color palette for a slime variant. Each is (R, G, B, A)."""

    main: tuple[int, int, int, int]
    highlight: tuple[int, int, int, int]
    shadow: tuple[int, int, int, int]
    eye: tuple[int, int, int, int] = (0, 0, 0, 255)
    accent: tuple[int, int, int, int] | None = None
    extra: tuple[int, int, int, int] | None = None

    @staticmethod
    def from_hex(main: str, highlight: str, shadow: str,
                 eye: str = "#000000", accent: str | None = None,
                 extra: str | None = None,
                 main_alpha: int = 255) -> "SlimePalette":
        return SlimePalette(
            main=hex_to_rgba(main, main_alpha),
            highlight=hex_to_rgba(highlight),
            shadow=hex_to_rgba(shadow),
            eye=hex_to_rgba(eye),
            accent=hex_to_rgba(accent) if accent else None,
            extra=hex_to_rgba(extra) if extra else None,
        )


def hex_to_rgba(hex_str: str, alpha: int = 255) -> tuple[int, int, int, int]:
    s = hex_str.lstrip("#")
    return (
        int(s[0:2], 16),
        int(s[2:4], 16),
        int(s[4:6], 16),
        alpha,
    )


# ---------------------------------------------------------------------------
# Canvas helpers
# ---------------------------------------------------------------------------

def new_canvas(size: int = 16) -> Image.Image:
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
# Slime drawing primitives
# ---------------------------------------------------------------------------

def draw_slime_body(
    img: Image.Image,
    palette: SlimePalette,
    *,
    cx: int = 8,
    cy: int = 10,
    width: int = 12,
    height: int = 8,
    squash: float = 0.0,
) -> None:
    """Draw the slime body shape (rounded blob).

    Args:
        cx, cy: Center of body
        width, height: Body dimensions
        squash: -1.0 (max squash) to +1.0 (max stretch)
    """
    draw = ImageDraw.Draw(img)

    # Apply squash/stretch
    w = max(1, int(width * (1 - squash * 0.4)))
    h = max(1, int(height * (1 + squash * 0.4)))

    # Bottom flat (slime sits on ground)
    bottom_y = cy + h // 2

    # Main body (filled rounded rect using ellipse)
    left = cx - w // 2
    right = cx + w // 2
    top = bottom_y - h
    bottom = bottom_y

    # Use rounded rectangle by drawing ellipses for top corners + rect for body
    # For pixel art, use simpler approach: ellipse for top half, rect for bottom
    draw.ellipse([left, top, right, top + h - 2], fill=palette.main)
    draw.rectangle([left, top + h // 2, right, bottom], fill=palette.main)

    # Shadow (bottom darker stripe)
    shadow_y = bottom - 2
    draw.rectangle([left + 1, shadow_y, right - 1, bottom], fill=palette.shadow)

    # Highlight (top-left small rect)
    hl_x = left + 2
    hl_y = top + 1
    draw.rectangle([hl_x, hl_y, hl_x + 2, hl_y + 1], fill=palette.highlight)


def draw_eyes(
    img: Image.Image,
    palette: SlimePalette,
    *,
    eye_y: int = 10,
    cx: int = 8,
    spacing: int = 3,
    closed: bool = False,
    excited: bool = False,
    size: int = 1,
) -> None:
    """Draw slime eyes."""
    draw = ImageDraw.Draw(img)
    left_x = cx - spacing
    right_x = cx + spacing - 1

    if closed:
        # Closed eyes (^_^)
        draw.line([left_x - 1, eye_y, left_x + 1, eye_y], fill=palette.eye)
        draw.line([right_x - 1, eye_y, right_x + 1, eye_y], fill=palette.eye)
    elif excited:
        # Wide eyes (O.O)
        draw.rectangle([left_x - 1, eye_y, left_x + 1, eye_y + 2], fill=(255, 255, 255, 255))
        draw.rectangle([right_x - 1, eye_y, right_x + 1, eye_y + 2], fill=(255, 255, 255, 255))
        draw.point((left_x, eye_y + 1), fill=palette.eye)
        draw.point((right_x, eye_y + 1), fill=palette.eye)
    else:
        # Normal dot eyes
        if size == 1:
            draw.point((left_x, eye_y), fill=palette.eye)
            draw.point((right_x, eye_y), fill=palette.eye)
        else:
            draw.rectangle([left_x, eye_y, left_x + size - 1, eye_y + size - 1], fill=palette.eye)
            draw.rectangle([right_x, eye_y, right_x + size - 1, eye_y + size - 1], fill=palette.eye)


def draw_ground_shadow(img: Image.Image, *, cy: int = 14, width: int = 10, alpha: int = 80) -> None:
    """Draw oval ground shadow."""
    draw = ImageDraw.Draw(img)
    cx = img.width // 2
    left = cx - width // 2
    right = cx + width // 2
    draw.ellipse([left, cy, right, cy + 2], fill=(0, 0, 0, alpha))


# ---------------------------------------------------------------------------
# Animation generators (return list of frames)
# ---------------------------------------------------------------------------

def gen_idle_frames(
    palette: SlimePalette,
    *,
    canvas_size: int = 16,
    frame_count: int = 4,
    body_w: int = 12,
    body_h: int = 8,
    extra_decorate=None,
) -> list[Image.Image]:
    """Generate idle breathing frames."""
    frames = []
    for i in range(frame_count):
        # Squash phase: 0 -> +0.2 -> 0 -> -0.2 (breathe)
        phase = i / frame_count
        squash = 0.2 * math.sin(phase * 2 * math.pi)
        img = new_canvas(canvas_size)
        draw_ground_shadow(img)
        draw_slime_body(img, palette, width=body_w, height=body_h, squash=squash)
        draw_eyes(img, palette, eye_y=10 - int(squash * 1))
        if extra_decorate:
            extra_decorate(img, palette, frame=i)
        frames.append(img)
    return frames


def gen_jump_frames(
    palette: SlimePalette,
    *,
    canvas_size: int = 16,
    body_w: int = 12,
    body_h: int = 8,
    extra_decorate=None,
) -> list[Image.Image]:
    """Generate 4-frame jump cycle."""
    # Frame 0: squash (about to jump)
    # Frame 1: stretch (going up)
    # Frame 2: peak (in air)
    # Frame 3: landing squash
    configs = [
        {"squash": -0.4, "y_offset": 0},   # squash on ground
        {"squash": 0.3, "y_offset": -2},   # stretch leaving ground
        {"squash": 0.1, "y_offset": -4},   # in the air
        {"squash": -0.2, "y_offset": -1},  # landing
    ]

    frames = []
    for i, cfg in enumerate(configs):
        img = new_canvas(canvas_size)
        # Shadow scales inversely with height
        shadow_alpha = max(30, 80 + cfg["y_offset"] * 10)
        shadow_w = max(6, body_w + cfg["y_offset"])
        draw_ground_shadow(img, width=shadow_w, alpha=shadow_alpha)

        # Body (offset upward for jump)
        cy = 10 + cfg["y_offset"]
        draw_slime_body(img, palette, cy=cy, width=body_w, height=body_h, squash=cfg["squash"])
        draw_eyes(img, palette, eye_y=cy - int(cfg["squash"] * 1))
        if extra_decorate:
            extra_decorate(img, palette, frame=i)
        frames.append(img)
    return frames


def gen_hurt_frames(
    palette: SlimePalette,
    *,
    canvas_size: int = 16,
    body_w: int = 12,
    body_h: int = 8,
    extra_decorate=None,
) -> list[Image.Image]:
    """Generate 2-frame hurt animation."""
    # Frame 0: white flash (entire body white)
    # Frame 1: normal but with sad eyes
    frames = []

    # Frame 0: White-flashed
    white_palette = SlimePalette(
        main=(255, 255, 255, 255),
        highlight=(255, 255, 255, 255),
        shadow=(220, 220, 220, 255),
        eye=palette.eye,
        accent=palette.accent,
        extra=palette.extra,
    )
    img0 = new_canvas(canvas_size)
    draw_ground_shadow(img0)
    draw_slime_body(img0, white_palette, width=body_w, height=body_h, squash=-0.1)
    draw_eyes(img0, white_palette, eye_y=10)
    frames.append(img0)

    # Frame 1: Normal with hurt look
    img1 = new_canvas(canvas_size)
    draw_ground_shadow(img1)
    draw_slime_body(img1, palette, width=body_w, height=body_h, squash=0.0)
    draw_eyes(img1, palette, eye_y=10, closed=True)  # Sad closed eyes
    frames.append(img1)
    return frames


def gen_death_frames(
    palette: SlimePalette,
    *,
    canvas_size: int = 16,
    body_w: int = 12,
    body_h: int = 8,
    frame_count: int = 6,
    extra_decorate=None,
) -> list[Image.Image]:
    """Generate death animation frames (slime dissolves)."""
    frames = []
    for i in range(frame_count):
        progress = i / (frame_count - 1)  # 0 to 1
        img = new_canvas(canvas_size)

        # Shadow shrinks
        shadow_w = max(2, int(body_w * (1 - progress)))
        draw_ground_shadow(img, width=shadow_w, alpha=int(80 * (1 - progress)))

        # Body shrinks and fades
        if progress < 1.0:
            scale = 1 - progress * 0.7
            current_w = max(2, int(body_w * scale))
            current_h = max(2, int(body_h * scale))
            cy = 10 + int(progress * 4)  # sinks slightly

            faded_alpha = int(255 * (1 - progress))
            faded = SlimePalette(
                main=(*palette.main[:3], faded_alpha),
                highlight=(*palette.highlight[:3], faded_alpha),
                shadow=(*palette.shadow[:3], faded_alpha),
                eye=(*palette.eye[:3], faded_alpha),
            )
            draw_slime_body(img, faded, cy=cy, width=current_w, height=current_h)

        # Add scattered droplets (more as it dies)
        droplet_count = int(progress * 8)
        cx = canvas_size // 2
        for j in range(droplet_count):
            angle = 2 * math.pi * j / max(droplet_count, 1)
            distance = int(progress * 6)
            dx = int(math.cos(angle) * distance)
            dy = int(math.sin(angle) * distance)
            x = cx + dx
            y = 10 + dy
            if 0 <= x < canvas_size and 0 <= y < canvas_size:
                # Single pixel droplet
                droplet_alpha = int(200 * (1 - progress))
                img.putpixel((x, y), (*palette.main[:3], droplet_alpha))

        if extra_decorate:
            extra_decorate(img, palette, frame=i, progress=progress)

        frames.append(img)
    return frames


# ---------------------------------------------------------------------------
# Main runner
# ---------------------------------------------------------------------------

def generate_all_animations(
    palette: SlimePalette,
    out_dir: str,
    species_id: str,
    *,
    canvas_size: int = 16,
    body_w: int = 12,
    body_h: int = 8,
    extra_decorate=None,
) -> None:
    """Generate full animation set for a slime species."""
    print(f"Generating: {species_id}")

    idle = gen_idle_frames(palette, canvas_size=canvas_size, body_w=body_w, body_h=body_h,
                           extra_decorate=extra_decorate)
    save_spritesheet(idle, out_dir, f"slime_{species_id}_idle")

    jump = gen_jump_frames(palette, canvas_size=canvas_size, body_w=body_w, body_h=body_h,
                           extra_decorate=extra_decorate)
    save_spritesheet(jump, out_dir, f"slime_{species_id}_jump")

    hurt = gen_hurt_frames(palette, canvas_size=canvas_size, body_w=body_w, body_h=body_h,
                           extra_decorate=extra_decorate)
    save_spritesheet(hurt, out_dir, f"slime_{species_id}_hurt")

    death = gen_death_frames(palette, canvas_size=canvas_size, body_w=body_w, body_h=body_h,
                             extra_decorate=extra_decorate)
    save_spritesheet(death, out_dir, f"slime_{species_id}_death")

    print(f"  ✓ {species_id} complete")
