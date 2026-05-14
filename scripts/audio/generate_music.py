"""Generate dungeon BGM tracks (chiptune style) using only stdlib.

Three loops:
- bgm_dungeon.wav  ~32s minor key dungeon crawl loop
- bgm_combat.wav   ~24s faster combat loop
- bgm_menu.wav     ~20s mellow menu/title loop
"""
from __future__ import annotations

import math
import os
import struct
import wave

SR = 22050
OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "assets", "audio")


def write_wav(name: str, samples: list[float], gain: float = 0.4) -> None:
    os.makedirs(OUT_DIR, exist_ok=True)
    path = os.path.join(OUT_DIR, f"{name}.wav")
    data = bytearray()
    for s in samples:
        v = int(max(-1.0, min(1.0, s * gain)) * 32767)
        data.extend(struct.pack("<h", v))
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(bytes(data))
    print(f"  -> {path} ({len(samples) / SR:.1f}s)")


def square(freq: float, t: float, duty: float = 0.5) -> float:
    return 1.0 if math.fmod(freq * t, 1.0) < duty else -1.0


def triangle(freq: float, t: float) -> float:
    p = math.fmod(freq * t, 1.0)
    return 4 * abs(p - 0.5) - 1


def sine(freq: float, t: float) -> float:
    return math.sin(2 * math.pi * freq * t)


def saw(freq: float, t: float) -> float:
    return 2 * math.fmod(freq * t, 1.0) - 1.0


def adsr(length: int, a: float = 0.01, d: float = 0.05, s: float = 0.7,
         r: float = 0.05) -> list[float]:
    """ADSR envelope. Length in samples."""
    av = max(1, int(SR * a))
    dv = max(1, int(SR * d))
    rv = max(1, int(SR * r))
    sv = max(0, length - av - dv - rv)
    env = [0.0] * length
    idx = 0
    for i in range(min(av, length)):
        env[idx] = i / av
        idx += 1
    for i in range(min(dv, length - idx)):
        env[idx] = 1.0 - (1.0 - s) * (i / dv)
        idx += 1
    for i in range(min(sv, length - idx)):
        env[idx] = s
        idx += 1
    for i in range(min(rv, length - idx)):
        env[idx] = s * (1.0 - i / rv)
        idx += 1
    return env


# Note frequencies (just intonation A4 = 440)
NOTE = {
    "A2": 110.0, "B2": 123.5, "C3": 130.8, "D3": 146.8, "E3": 164.8,
    "F3": 174.6, "G3": 196.0, "A3": 220.0, "B3": 246.9,
    "C4": 261.6, "D4": 293.7, "E4": 329.6, "F4": 349.2, "G4": 392.0,
    "A4": 440.0, "B4": 493.9, "C5": 523.3, "D5": 587.3, "E5": 659.3,
    "F5": 698.5, "G5": 784.0, "A5": 880.0,
    "REST": 0.0,
}


def render_seq(seq: list[tuple[str, float]], wave_fn=square,
               vol: float = 0.6, sustain: float = 0.6) -> list[float]:
    """Render a list of (note_name, duration_seconds) into samples."""
    out = []
    for note, dur in seq:
        n = int(SR * dur)
        if note == "REST":
            out.extend([0.0] * n)
            continue
        f = NOTE[note]
        env = adsr(n, a=0.005, d=0.05, s=sustain, r=min(0.05, dur * 0.3))
        for i in range(n):
            t = i / SR
            out.append(wave_fn(f, t) * vol * env[i])
    return out


def mix(*tracks: list[float], gains: list[float] | None = None) -> list[float]:
    if not tracks:
        return []
    n = max(len(t) for t in tracks)
    g = gains if gains else [1.0] * len(tracks)
    out = [0.0] * n
    for ti, t in enumerate(tracks):
        for i in range(len(t)):
            out[i] += t[i] * g[ti]
    # Normalize
    peak = max((abs(v) for v in out), default=1.0)
    if peak > 1.0:
        out = [v / peak for v in out]
    return out


def bgm_dungeon() -> list[float]:
    """Eerie dungeon loop — A minor at 90 BPM."""
    bpm = 90
    beat = 60.0 / bpm  # 0.667 s
    eighth = beat / 2
    quarter = beat
    half = beat * 2

    # Bass line (one bar = 4 beats)
    bass = [
        ("A2", quarter), ("A2", quarter), ("E2".replace("E2", "E3"), quarter), ("A2", quarter),
        ("F3", quarter), ("F3", quarter), ("C3", quarter), ("F3", quarter),
        ("G3", quarter), ("G3", quarter), ("D3", quarter), ("G3", quarter),
        ("E3", quarter), ("E3", quarter), ("B2", quarter), ("E3", quarter),
    ] * 2

    # Lead melody
    lead = [
        ("A4", eighth), ("C5", eighth), ("E5", eighth), ("A5", eighth),
        ("E5", quarter), ("REST", quarter),
        ("F4", eighth), ("A4", eighth), ("C5", eighth), ("F5", eighth),
        ("C5", quarter), ("REST", quarter),
        ("G4", eighth), ("B4", eighth), ("D5", eighth), ("G5", eighth),
        ("D5", quarter), ("REST", quarter),
        ("E4", eighth), ("G4", eighth), ("B4", eighth), ("E5", eighth),
        ("B4", quarter), ("REST", quarter),
    ] * 2

    bass_track = render_seq(bass, square, vol=0.55, sustain=0.4)
    lead_track = render_seq(lead, triangle, vol=0.55, sustain=0.6)

    # Pad: slow sine drone
    pad = []
    drone_dur = sum(d for _, d in bass)
    for i in range(int(SR * drone_dur)):
        t = i / SR
        # A2 drone with slow modulation
        s = sine(110, t) * 0.3 + sine(220, t) * 0.2 + sine(165, t) * 0.15
        env = 0.5 + 0.5 * math.sin(2 * math.pi * 0.1 * t)
        pad.append(s * env * 0.4)

    return mix(bass_track, lead_track, pad, gains=[0.5, 0.5, 0.4])


def bgm_combat() -> list[float]:
    """Faster combat loop in E minor at 130 BPM."""
    bpm = 130
    beat = 60.0 / bpm
    eighth = beat / 2
    sixteenth = beat / 4
    quarter = beat

    # Driving bass (eighth notes)
    bass = [
        ("E3", eighth), ("E3", eighth), ("E3", eighth), ("E3", eighth),
        ("E3", eighth), ("E3", eighth), ("G3", eighth), ("B3", eighth),
        ("D4", eighth), ("D4", eighth), ("D4", eighth), ("D4", eighth),
        ("D4", eighth), ("D4", eighth), ("F4", eighth), ("A4", eighth),
        ("C4", eighth), ("C4", eighth), ("C4", eighth), ("C4", eighth),
        ("C4", eighth), ("C4", eighth), ("E4", eighth), ("G4", eighth),
        ("B3", eighth), ("B3", eighth), ("B3", eighth), ("B3", eighth),
        ("B3", eighth), ("B3", eighth), ("D4", eighth), ("F4", eighth),
    ]

    # Aggressive lead - sixteenth riffs
    lead = [
        ("E5", sixteenth), ("G5", sixteenth), ("E5", sixteenth), ("B4", sixteenth),
        ("E5", sixteenth), ("G5", sixteenth), ("E5", sixteenth), ("D5", sixteenth),
        ("E5", quarter),
        ("D5", sixteenth), ("F5", sixteenth), ("D5", sixteenth), ("A4", sixteenth),
        ("D5", sixteenth), ("F5", sixteenth), ("D5", sixteenth), ("C5", sixteenth),
        ("D5", quarter),
        ("C5", sixteenth), ("E5", sixteenth), ("C5", sixteenth), ("G4", sixteenth),
        ("C5", sixteenth), ("E5", sixteenth), ("C5", sixteenth), ("B4", sixteenth),
        ("C5", quarter),
        ("B4", sixteenth), ("D5", sixteenth), ("B4", sixteenth), ("F4", sixteenth),
        ("B4", sixteenth), ("D5", sixteenth), ("B4", sixteenth), ("A4", sixteenth),
        ("B4", quarter),
    ]

    bass_track = render_seq(bass, square, vol=0.55, sustain=0.5)
    lead_track = render_seq(lead, triangle, vol=0.6, sustain=0.5)
    return mix(bass_track, lead_track, gains=[0.55, 0.55])


def bgm_menu() -> list[float]:
    """Mellow menu loop in C major at 70 BPM."""
    bpm = 70
    beat = 60.0 / bpm
    quarter = beat
    half = beat * 2
    eighth = beat / 2

    bass = [
        ("C3", half), ("E3", half),
        ("F3", half), ("A3", half),
        ("G3", half), ("B3", half),
        ("C4", half), ("REST", half),
    ] * 2

    melody = [
        ("E5", quarter), ("G5", quarter), ("E5", quarter), ("C5", quarter),
        ("F5", quarter), ("A5", quarter), ("F5", quarter), ("C5", quarter),
        ("G5", quarter), ("B5".replace("B5", "B4"), quarter), ("D5", quarter), ("G4", quarter),
        ("C5", quarter), ("E5", quarter), ("G5", quarter), ("C5", quarter),
    ] * 2

    bass_track = render_seq(bass, triangle, vol=0.5, sustain=0.65)
    lead_track = render_seq(melody, sine, vol=0.55, sustain=0.7)
    return mix(bass_track, lead_track, gains=[0.5, 0.5])


def main():
    print("Generating BGM...")
    write_wav("bgm_dungeon", bgm_dungeon(), gain=0.4)
    write_wav("bgm_combat", bgm_combat(), gain=0.4)
    write_wav("bgm_menu", bgm_menu(), gain=0.4)
    print("Done.")


if __name__ == "__main__":
    main()
