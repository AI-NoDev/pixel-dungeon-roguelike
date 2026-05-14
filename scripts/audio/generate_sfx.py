"""Generate sound effects for POP! Slime using pure-Python wave + math.

Outputs short 16-bit mono WAV files into assets/audio/. No external deps.

Sounds produced:
- shoot.wav         pistol pew
- shoot_heavy.wav   bigger boom (rocket/sniper)
- shoot_laser.wav   sweep
- hit.wav           enemy hit
- crit.wav          critical hit
- player_hurt.wav   damage taken
- pickup_gold.wav   gold pickup ding
- pickup_item.wav   item pickup chime
- pickup_weapon.wav weapon pickup chime
- pickup_talent.wav talent pickup magical sparkle
- slime_die.wav     squish
- footstep.wav      soft thud
- level_up.wav      ascending arpeggio
- door_open.wav     stone slide
- explosion.wav     boom
"""
from __future__ import annotations

import math
import os
import random
import struct
import wave

SR = 22050  # sample rate
OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "assets", "audio")


def write_wav(name: str, samples: list[float], gain: float = 0.7) -> None:
    os.makedirs(OUT_DIR, exist_ok=True)
    path = os.path.join(OUT_DIR, f"{name}.wav")
    # Clamp samples and convert to int16
    data = bytearray()
    for s in samples:
        v = int(max(-1.0, min(1.0, s * gain)) * 32767)
        data.extend(struct.pack("<h", v))
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(bytes(data))
    print(f"  -> {path} ({len(samples)/SR*1000:.0f} ms)")


# ---------------------------------------------------------------------------
# Synthesis primitives
# ---------------------------------------------------------------------------

def envelope_ad(length: int, attack: float = 0.01, decay: float = 0.1) -> list[float]:
    """Attack/Decay envelope, length in samples."""
    a = max(1, int(SR * attack))
    d = max(1, int(SR * decay))
    env = [0.0] * length
    for i in range(min(a, length)):
        env[i] = i / a
    peak = min(a, length)
    for i in range(peak, length):
        rel = (i - peak) / max(1, d)
        env[i] = max(0.0, 1.0 - rel)
    return env


def sine(freq: float, t: float) -> float:
    return math.sin(2 * math.pi * freq * t)


def square(freq: float, t: float) -> float:
    return 1.0 if math.fmod(freq * t, 1.0) < 0.5 else -1.0


def triangle(freq: float, t: float) -> float:
    p = math.fmod(freq * t, 1.0)
    return 4 * abs(p - 0.5) - 1


def saw(freq: float, t: float) -> float:
    return 2 * math.fmod(freq * t, 1.0) - 1.0


def noise() -> float:
    return random.uniform(-1, 1)


# ---------------------------------------------------------------------------
# Specific SFX
# ---------------------------------------------------------------------------

def gen_shoot() -> list[float]:
    """Pew laser-pistol sound."""
    dur = 0.10
    n = int(SR * dur)
    env = envelope_ad(n, 0.001, 0.09)
    out = []
    for i in range(n):
        t = i / SR
        # Frequency sweep down from 1500Hz to 400Hz
        freq = 1500 - 1100 * (i / n)
        s = square(freq, t) * 0.6 + saw(freq * 0.5, t) * 0.3
        out.append(s * env[i])
    return out


def gen_shoot_heavy() -> list[float]:
    """Boom from rocket/sniper."""
    dur = 0.30
    n = int(SR * dur)
    env = envelope_ad(n, 0.005, 0.28)
    out = []
    for i in range(n):
        t = i / SR
        # Low rumble + crackle
        rumble = sine(60 + 120 * (i / n), t)
        crack = noise() * (1 - i / n)
        out.append((rumble * 0.6 + crack * 0.5) * env[i])
    return out


def gen_shoot_laser() -> list[float]:
    """Continuous laser beam zap."""
    dur = 0.20
    n = int(SR * dur)
    env = envelope_ad(n, 0.005, 0.18)
    out = []
    for i in range(n):
        t = i / SR
        freq = 800 + 200 * math.sin(t * 50)
        out.append(saw(freq, t) * 0.6 * env[i])
    return out


def gen_hit() -> list[float]:
    dur = 0.08
    n = int(SR * dur)
    env = envelope_ad(n, 0.001, 0.07)
    out = []
    for i in range(n):
        t = i / SR
        s = noise() * 0.7 + sine(180, t) * 0.5
        out.append(s * env[i])
    return out


def gen_crit() -> list[float]:
    dur = 0.18
    n = int(SR * dur)
    env = envelope_ad(n, 0.005, 0.15)
    out = []
    for i in range(n):
        t = i / SR
        # Two-tone crit ping
        pitch = 440 + 200 * (i / n)
        s = sine(pitch, t) * 0.5 + sine(pitch * 1.5, t) * 0.4 + noise() * 0.2 * (1 - i / n)
        out.append(s * env[i])
    return out


def gen_player_hurt() -> list[float]:
    dur = 0.20
    n = int(SR * dur)
    env = envelope_ad(n, 0.005, 0.18)
    out = []
    for i in range(n):
        t = i / SR
        # Falling pitch grunt
        f = 250 - 100 * (i / n)
        s = saw(f, t) * 0.6 + noise() * 0.4
        out.append(s * env[i])
    return out


def gen_pickup_gold() -> list[float]:
    dur = 0.18
    n = int(SR * dur)
    env = envelope_ad(n, 0.002, 0.15)
    out = []
    for i in range(n):
        t = i / SR
        # Two ascending tones
        f = 880 if i < n // 2 else 1320
        out.append(triangle(f, t) * 0.7 * env[i])
    return out


def gen_pickup_item() -> list[float]:
    dur = 0.22
    n = int(SR * dur)
    env = envelope_ad(n, 0.003, 0.20)
    out = []
    for i in range(n):
        t = i / SR
        f = 660 + 200 * math.sin(t * 30)
        out.append(sine(f, t) * 0.6 * env[i])
    return out


def gen_pickup_weapon() -> list[float]:
    dur = 0.25
    n = int(SR * dur)
    env = envelope_ad(n, 0.005, 0.22)
    out = []
    for i in range(n):
        t = i / SR
        # Metallic clink
        s = (sine(1200, t) * 0.4 +
             sine(1800, t) * 0.3 +
             noise() * 0.3 * math.exp(-i * 20.0 / SR))
        out.append(s * env[i])
    return out


def gen_pickup_talent() -> list[float]:
    """Magical sparkle — ascending arpeggio."""
    dur = 0.40
    n = int(SR * dur)
    env = envelope_ad(n, 0.005, 0.38)
    out = []
    notes = [523, 659, 784, 1047]  # C major arpeggio C5-E5-G5-C6
    for i in range(n):
        t = i / SR
        idx = min(len(notes) - 1, int(i / n * len(notes)))
        f = notes[idx]
        s = sine(f, t) * 0.5 + sine(f * 2, t) * 0.2
        out.append(s * env[i])
    return out


def gen_slime_die() -> list[float]:
    dur = 0.30
    n = int(SR * dur)
    env = envelope_ad(n, 0.01, 0.28)
    out = []
    for i in range(n):
        t = i / SR
        # Wet squish - low pitch + filtered noise
        s = (sine(120 - 60 * (i / n), t) * 0.5 +
             noise() * 0.5 * (1 - i / n))
        out.append(s * env[i])
    return out


def gen_footstep() -> list[float]:
    dur = 0.06
    n = int(SR * dur)
    env = envelope_ad(n, 0.005, 0.05)
    out = []
    for i in range(n):
        s = noise() * 0.6 + sine(80, i / SR) * 0.3
        out.append(s * env[i])
    return out


def gen_level_up() -> list[float]:
    dur = 0.55
    n = int(SR * dur)
    env = envelope_ad(n, 0.005, 0.50)
    out = []
    notes = [392, 523, 659, 784, 1047]  # G4 → C6
    note_len = n // len(notes)
    for i in range(n):
        idx = min(len(notes) - 1, i // max(1, note_len))
        t_in_note = (i % max(1, note_len)) / SR
        f = notes[idx]
        s = sine(f, t_in_note) * 0.4 + sine(f * 2, t_in_note) * 0.2
        out.append(s * env[i])
    return out


def gen_door_open() -> list[float]:
    dur = 0.40
    n = int(SR * dur)
    env = envelope_ad(n, 0.05, 0.35)
    out = []
    for i in range(n):
        t = i / SR
        # Stone slide
        s = saw(70 + 30 * (i / n), t) * 0.5 + noise() * 0.5
        out.append(s * env[i])
    return out


def gen_explosion() -> list[float]:
    dur = 0.45
    n = int(SR * dur)
    env = envelope_ad(n, 0.005, 0.40)
    out = []
    for i in range(n):
        t = i / SR
        # Layered low rumble + crackle
        rumble = sine(45 + 60 * (1 - i / n), t)
        crack = noise() * (1 - i / n) ** 0.5
        out.append((rumble * 0.5 + crack * 0.7) * env[i])
    return out


def main():
    print("Generating SFX...")
    write_wav("shoot", gen_shoot(), gain=0.55)
    write_wav("shoot_heavy", gen_shoot_heavy(), gain=0.65)
    write_wav("shoot_laser", gen_shoot_laser(), gain=0.55)
    write_wav("hit", gen_hit(), gain=0.55)
    write_wav("crit", gen_crit(), gain=0.65)
    write_wav("player_hurt", gen_player_hurt(), gain=0.65)
    write_wav("pickup_gold", gen_pickup_gold(), gain=0.55)
    write_wav("pickup_item", gen_pickup_item(), gain=0.55)
    write_wav("pickup_weapon", gen_pickup_weapon(), gain=0.6)
    write_wav("pickup_talent", gen_pickup_talent(), gain=0.55)
    write_wav("slime_die", gen_slime_die(), gain=0.55)
    write_wav("footstep", gen_footstep(), gain=0.4)
    write_wav("level_up", gen_level_up(), gain=0.55)
    write_wav("door_open", gen_door_open(), gain=0.55)
    write_wav("explosion", gen_explosion(), gain=0.7)
    print("Done.")


if __name__ == "__main__":
    main()
