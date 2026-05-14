"""Additional weapon shapes for extended weapon types."""
from PIL import ImageDraw


def draw_laser(img, palette):
    """Draw a futuristic laser gun."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Body
    draw.rectangle([cx - 6, cy - 1, cx + 4, cy + 3], fill=palette.main)
    draw.rectangle([cx - 6, cy - 1, cx + 4, cy], fill=palette.highlight)
    # Long barrel with energy chambers
    draw.rectangle([cx + 4, cy, cx + 9, cy + 1], fill=palette.shadow)
    # Energy core
    if palette.glow:
        draw.point((cx, cy + 1), fill=palette.glow)
        draw.point((cx + 1, cy + 1), fill=palette.glow)
        draw.point((cx + 2, cy + 1), fill=palette.glow)
    # Sci-fi grip
    draw.rectangle([cx - 6, cy + 3, cx - 4, cy + 6], fill=palette.shadow)
    # Trigger guard angled
    draw.point((cx - 4, cy + 4), fill=palette.main)


def draw_rocket(img, palette):
    """Draw a rocket launcher."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Main tube (large barrel)
    draw.rectangle([cx - 8, cy - 2, cx + 9, cy + 3], fill=palette.main)
    # Top highlight
    draw.rectangle([cx - 8, cy - 2, cx + 9, cy - 2], fill=palette.highlight)
    # Bottom shadow
    draw.rectangle([cx - 8, cy + 3, cx + 9, cy + 3], fill=palette.shadow)
    # Front muzzle (slightly wider)
    draw.rectangle([cx + 7, cy - 3, cx + 9, cy + 4], fill=palette.shadow)
    # Sight on top
    draw.rectangle([cx - 2, cy - 4, cx + 1, cy - 3], fill=palette.shadow)
    # Trigger area
    draw.rectangle([cx - 5, cy + 4, cx - 2, cy + 6], fill=palette.shadow)
    # Glow at front
    if palette.glow:
        draw.point((cx + 9, cy + 1), fill=palette.glow)
        draw.point((cx + 9, cy), fill=palette.glow)


def draw_knife(img, palette):
    """Draw throwing knives (3 daggers)."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Three daggers in fan pattern
    for i, angle_offset in enumerate([-3, 0, 3]):
        # Blade
        bx = cx - 4
        by = cy + angle_offset
        draw.line([bx, by, bx + 8, by], fill=palette.main)
        draw.point((bx + 8, by), fill=palette.highlight)
        # Hilt
        draw.point((bx, by), fill=palette.accent or palette.shadow)
        draw.point((bx + 1, by), fill=palette.accent or palette.shadow)
        # Sharp tip glint
        if palette.glow:
            draw.point((bx + 8, by - 1), fill=palette.glow)


def draw_compound_bow(img, palette):
    """Draw a compound bow with mechanical pulleys."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Top limb (curved)
    points_top = [(cx - 5, cy - 6), (cx - 7, cy - 4), (cx - 8, cy - 1)]
    for px, py in points_top:
        draw.point((px, py), fill=palette.main)
    # Bottom limb (curved)
    points_bot = [(cx - 5, cy + 6), (cx - 7, cy + 4), (cx - 8, cy + 1)]
    for px, py in points_bot:
        draw.point((px, py), fill=palette.main)
    # Center riser (vertical)
    draw.line([cx - 4, cy - 4, cx - 4, cy + 4], fill=palette.shadow)
    # Pulleys (top and bottom)
    draw.point((cx - 8, cy - 1), fill=palette.highlight)
    draw.point((cx - 8, cy + 1), fill=palette.highlight)
    # Bowstring (taut, drawn)
    draw.line([cx - 8, cy - 1, cx + 5, cy], fill=palette.highlight)
    draw.line([cx - 8, cy + 1, cx + 5, cy], fill=palette.highlight)
    # Arrow
    draw.line([cx - 2, cy, cx + 8, cy], fill=palette.shadow)
    draw.point((cx + 8, cy), fill=(255, 215, 0, 255))


def draw_crossbow(img, palette):
    """Draw a crossbow with horizontal bow arms."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    cx, cy = w // 2, h // 2

    # Stock (horizontal body)
    draw.rectangle([cx - 5, cy - 1, cx + 5, cy + 2], fill=palette.shadow)
    # Bow arms (horizontal at front)
    draw.line([cx + 5, cy - 4, cx + 5, cy + 5], fill=palette.main)
    draw.line([cx + 4, cy - 4, cx + 4, cy + 5], fill=palette.main)
    # Bowstring
    draw.line([cx + 4, cy - 4, cx, cy], fill=palette.highlight)
    draw.line([cx + 4, cy + 4, cx, cy + 1], fill=palette.highlight)
    # Bolt (arrow ready to fire)
    draw.line([cx, cy, cx + 9, cy], fill=palette.accent or palette.main)
    if palette.glow:
        draw.point((cx + 9, cy), fill=palette.glow)
    # Trigger / grip
    draw.rectangle([cx - 5, cy + 2, cx - 3, cy + 5], fill=palette.shadow)
