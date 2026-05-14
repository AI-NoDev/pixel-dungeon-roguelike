#!/usr/bin/env python3
"""Run all slime generation scripts in sequence.

Usage:
    python3 generate_all.py
"""
import glob
import os
import subprocess
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))


def main():
    # Find all numbered slime scripts
    scripts = sorted(glob.glob(os.path.join(SCRIPT_DIR, "[0-9][0-9]_*.py")))

    if not scripts:
        print("No slime scripts found!")
        return 1

    print(f"Found {len(scripts)} slime scripts")
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

    out_dir = os.path.join(SCRIPT_DIR, "../../assets/images/slimes")
    if os.path.exists(out_dir):
        png_count = len(glob.glob(os.path.join(out_dir, "*.png")))
        print(f"📁 Generated {png_count} sprite files in:\n   {os.path.abspath(out_dir)}")

    return 0 if success_count == len(scripts) else 1


if __name__ == "__main__":
    sys.exit(main())
