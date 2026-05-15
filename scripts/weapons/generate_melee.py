"""Generate melee weapon sprites (24x24 pixel art)."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pixel_lib import new_canvas, save_frame, hex_to_rgba

from PIL import ImageDraw

OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "assets", "images", "weapons")


def draw_sword(img, blade_color, guard_color, handle_color):
    d = ImageDraw.Draw(img)
    # Handle
    d.rectangle([10, 18, 13, 22], fill=handle_color)
    # Guard
    d.rectangle([7, 16, 16, 18], fill=guard_color)
    # Blade
    d.rectangle([10, 4, 13, 16], fill=blade_color)
    # Tip
    d.polygon([(10, 4), (11, 2), (12, 4)], fill=blade_color)
    # Highlight
    d.line([(11, 5), (11, 14)], fill=hex_to_rgba("#FFFFFF", 180))


def draw_axe(img, head_color, handle_color):
    d = ImageDraw.Draw(img)
    # Handle
    d.rectangle([11, 8, 12, 22], fill=handle_color)
    # Axe head
    d.polygon([(6, 4), (11, 4), (11, 12), (4, 8)], fill=head_color)
    d.polygon([(12, 4), (17, 4), (19, 8), (12, 12)], fill=head_color)
    # Edge highlight
    d.line([(6, 4), (4, 8)], fill=hex_to_rgba("#FFFFFF", 150))


def draw_spear(img, tip_color, shaft_color):
    d = ImageDraw.Draw(img)
    # Shaft
    d.rectangle([11, 6, 12, 22], fill=shaft_color)
    # Spear tip
    d.polygon([(9, 6), (11, 2), (14, 6)], fill=tip_color)
    d.polygon([(10, 6), (11, 3), (13, 6)], fill=hex_to_rgba("#FFFFFF", 150))


def draw_hammer(img, head_color, handle_color):
    d = ImageDraw.Draw(img)
    # Handle
    d.rectangle([11, 10, 12, 22], fill=handle_color)
    # Hammer head
    d.rectangle([5, 4, 18, 10], fill=head_color)
    # Face highlight
    d.rectangle([6, 5, 8, 9], fill=hex_to_rgba("#FFFFFF", 100))


def main():
    print("Generating melee weapon sprites...")

    # Iron Sword
    img = new_canvas(24)
    draw_sword(img, hex_to_rgba("#BDBDBD"), hex_to_rgba("#795548"), hex_to_rgba("#5D4037"))
    save_frame(img, OUT_DIR, "weapon_iron_sword")

    # Flame Blade
    img = new_canvas(24)
    draw_sword(img, hex_to_rgba("#FF7043"), hex_to_rgba("#BF360C"), hex_to_rgba("#5D4037"))
    save_frame(img, OUT_DIR, "weapon_flame_blade")

    # Frost Edge
    img = new_canvas(24)
    draw_sword(img, hex_to_rgba("#4FC3F7"), hex_to_rgba("#0277BD"), hex_to_rgba("#37474F"))
    save_frame(img, OUT_DIR, "weapon_frost_edge")

    # Battle Axe
    img = new_canvas(24)
    draw_axe(img, hex_to_rgba("#8D6E63"), hex_to_rgba("#5D4037"))
    save_frame(img, OUT_DIR, "weapon_battle_axe")

    # Thunder Axe
    img = new_canvas(24)
    draw_axe(img, hex_to_rgba("#FFEB3B"), hex_to_rgba("#5D4037"))
    save_frame(img, OUT_DIR, "weapon_thunder_axe")

    # Long Spear
    img = new_canvas(24)
    draw_spear(img, hex_to_rgba("#BDBDBD"), hex_to_rgba("#795548"))
    save_frame(img, OUT_DIR, "weapon_long_spear")

    # Poison Spear
    img = new_canvas(24)
    draw_spear(img, hex_to_rgba("#9CCC65"), hex_to_rgba("#5D4037"))
    save_frame(img, OUT_DIR, "weapon_poison_spear")

    # War Hammer
    img = new_canvas(24)
    draw_hammer(img, hex_to_rgba("#616161"), hex_to_rgba("#5D4037"))
    save_frame(img, OUT_DIR, "weapon_war_hammer")

    # Holy Hammer
    img = new_canvas(24)
    draw_hammer(img, hex_to_rgba("#FFF59D"), hex_to_rgba("#5D4037"))
    save_frame(img, OUT_DIR, "weapon_holy_hammer")

    print("Done.")


if __name__ == "__main__":
    main()
