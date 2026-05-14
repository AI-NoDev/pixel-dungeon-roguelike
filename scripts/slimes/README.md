# Slime Sprite Generator

Python scripts that generate pixel art sprites for all 23 slime species programmatically.
**Zero AI cost. Zero artist time. Generated in 5 seconds.**

## Quick Start

```bash
# Install Pillow (Python image library)
pip3 install Pillow

# Generate ALL slimes at once
python3 generate_all.py

# Or generate a single slime
python3 01_green_slime.py
```

## Output

Sprites are written to:
```
../../assets/images/slimes/
```

Each slime gets 4 sprite sheets:
- `slime_<id>_idle.png` — 4 frames @ 6fps (breathing)
- `slime_<id>_jump.png` — 4 frames @ 8fps (movement)
- `slime_<id>_hurt.png` — 2 frames @ 8fps (white flash)
- `slime_<id>_death.png` — 6 frames @ 8fps (dissolve)

## Slime Index

| # | File | Species ID | Canvas | Description |
|---|------|------------|--------|-------------|
| 01 | green_slime | `green` | 16×16 | Classic green |
| 02 | pink_bouncer | `pink` | 16×16 | Hyperactive pink |
| 03 | acid_spitter | `acid` | 16×16 | Yellow acid |
| 04 | blue_frost_jelly | `frost` | 16×16 | Translucent ice |
| 05 | lava_bubbler | `lava` | 16×16 | Red molten |
| 06 | thunder_jolt | `thunder` | 16×16 | Yellow electric |
| 07 | toxic_goo | `toxic` | 16×16 | Purple poison |
| 08 | mega_goo | `mega` | 24×24 | Large teal tank |
| 09 | spike_slime | `spike` | 16×16 | Spiky defense |
| 10 | tar_slime | `tar` | 16×16 | Glossy black |
| 11 | mutant_slime | `mutant` | 16×16 | Color-shifting |
| 12 | crystalline_slime | `crystal` | 16×16 | Translucent purple |
| 13 | regenerating_slime | `regen` | 16×16 | Healing green |
| 14 | bomb_slime | `bomb` | 16×16 | TNT kamikaze |
| 15 | corrosive_slime | `corrosive` | 16×16 | Brown acid |
| 16 | phantom_slime | `phantom` | 16×16 | Translucent ghost |
| 17 | magnetic_slime | `magnetic` | 16×16 | Hazard stripes |
| 18 | rainbow_slime | `rainbow` | 16×16 | Legendary prismatic |
| 19 | slime_knight | `knight` | 24×24 | Armored elite |
| 20 | slime_mage | `mage` | 24×24 | Wizard elite |
| 21 | kings_guard | `guard` | 24×24 | Royal guard |
| 22 | slime_king | `king` | 48×48 | F5 BOSS |
| 23 | ancient_slime | `ancient` | 60×60 | Hidden BOSS |

## Customizing

Each script is self-contained. To tweak a slime:

1. Open the corresponding `XX_*.py`
2. Adjust `PALETTE` (colors) or `extra_decorate` (decorations)
3. Re-run the script

Common edits:

```python
# Change colors
PALETTE = SlimePalette.from_hex(
    main="#66BB6A",      # Body color
    highlight="#A5D6A7", # Top-left shine
    shadow="#2E7D32",    # Bottom shadow
    eye="#000000",       # Eye color
)

# Change body proportions
generate_all_animations(
    body_w=12,    # Wider/narrower
    body_h=8,     # Taller/shorter
    canvas_size=16,  # Frame size
)
```

## Architecture

```
_pixel_lib.py          ← Common utilities (palette, drawing, animation)
01-23_*.py             ← One script per slime species
generate_all.py         ← Batch runner
```

The library provides:
- `SlimePalette` — color management
- `draw_slime_body()` — body shape with squash/stretch
- `draw_eyes()` — multiple eye styles
- `gen_idle_frames()` — breathing loop
- `gen_jump_frames()` — jump cycle
- `gen_hurt_frames()` — damage feedback
- `gen_death_frames()` — dissolution

## Animation Details

Each animation uses pure Python + math, no external assets:

### Idle (4 frames)
Sin wave squash for breathing effect.

### Jump (4 frames)
1. Squash on ground (about to launch)
2. Stretch leaving ground
3. Floating in air with shrunk shadow
4. Landing squash

### Hurt (2 frames)
1. Full white flash (entire body white)
2. Recovery with closed/sad eyes

### Death (6 frames)
- Body shrinks and fades
- Particles radiate outward
- Shadow shrinks
- Optional element-specific effects per species

## File Sizes

Total output: ~92 PNG files, ~30 KB combined.
That's **less than a single Midjourney image**.

## Loading in Flutter

```dart
// pubspec.yaml — assets directory already configured
// assets:
//   - assets/images/slimes/

// Load a sprite sheet
final image = await Flame.images.load('slimes/slime_green_idle.png');
final spriteSize = Vector2(16, 16);
final spriteSheet = SpriteSheet(image: image, srcSize: spriteSize);
final animation = spriteSheet.createAnimation(row: 0, stepTime: 0.16);
```

## Future Improvements

If you want better quality later:
- Replace specific sprites with hand-drawn or AI-generated versions
- All scripts produce 8-bit pixel art that's easy to manually polish
- Use Aseprite to clean up edges if needed
- Consider tile-able patterns for body texture
