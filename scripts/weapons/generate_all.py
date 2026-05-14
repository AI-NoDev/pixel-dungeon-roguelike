#!/usr/bin/env python3
"""Generate all weapon and bullet sprites."""
import glob
import os
import subprocess
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))


def main():
    # Find all weapon scripts (numbered) and bullet scripts (B prefix)
    weapon_scripts = sorted(glob.glob(os.path.join(SCRIPT_DIR, "[0-9][0-9]_*.py")))
    bullet_scripts = sorted(glob.glob(os.path.join(SCRIPT_DIR, "B[0-9][0-9]_*.py")))
    scripts = weapon_scripts + bullet_scripts

    if not scripts:
        print("No scripts found!")
        return 1

    print(f"Found {len(weapon_scripts)} weapons + {len(bullet_scripts)} bullets")
    print("=" * 60)

    success_count = 0
    for script in scripts:
        name = os.path.basename(script)
        print(f"\n▶ Running {name}...")
        result = subprocess.run(
            [sys.executable, script],
            capture_output=True,
            text=True,
        )
        if result.returncode == 0:
            success_count += 1
            print(result.stdout.strip())
        else:
            print(f"  ✗ FAILED: {result.stderr}")

    print("\n" + "=" * 60)
    print(f"✓ {success_count}/{len(scripts)} scripts succeeded")

    weapon_dir = os.path.join(SCRIPT_DIR, "../../assets/images/weapons")
    bullet_dir = os.path.join(SCRIPT_DIR, "../../assets/images/bullets")
    weapon_count = len(glob.glob(os.path.join(weapon_dir, "*.png"))) if os.path.exists(weapon_dir) else 0
    bullet_count = len(glob.glob(os.path.join(bullet_dir, "*.png"))) if os.path.exists(bullet_dir) else 0
    print(f"📁 Generated {weapon_count} weapon icons + {bullet_count} bullet sprites")

    return 0 if success_count == len(scripts) else 1


if __name__ == "__main__":
    sys.exit(main())
