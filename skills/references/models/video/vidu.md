# Vidu Q2 — `vidu`
**Provider:** Shengshu Technology · **Underlying model:** Vidu Q2 · **Modality:** Text-, image-, and reference-to-video · **Audio:** Native (synchronized SFX/ambient + BGM)

Vidu Q2 is Shengshu's consistency-and-control model: its standout **reference-to-video** mode locks character faces, props, and costumes across a clip from multiple reference images, and it offers by far the **widest aspect-ratio support** of the rtst video models.

## rtst usage
```bash
rtst video create vidu --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `16:9`, `9:16`, `1:1`, `4:3`, `3:4`, `21:9`, `9:21`
- **Resolutions:** `540p`, `720p`, `1080p`
- **Durations (s):** `3`–`10`
- **Audio:** Yes — enable with `--audio` (off by default). Vidu can generate synchronized ambient sound and background music (BGM).
- **Image input (three modes):**
  - `--first-frame <file>` — start-frame image-to-video.
  - `--last-frame <file>` — pair with a first frame to interpolate the motion between two frames.
  - `--reference-image <file>` (repeatable) — reference-to-video; supply anchors for subject consistency. Vidu Q2 accepts up to ~7 reference images.
  - Local files auto-upload; URLs pass through.

## How to prompt it
Think like a director: define **Subject, Action, Environment, and Camera Angle**, then add lighting and mood. Vidu understands professional cinematography terms — *dolly-in, low-angle tracking, sweeping pan, crane* — and responds to fidelity cues ("high-fidelity motion," "1080p," "cinematic").

**Reference-to-video (the differentiator):**
- Provide **multiple angles of the same subject** (front, profile, back) so the model understands its 3D form and keeps identity stable.
- In the rtst pipeline you can tag subjects in the prompt with `@subject1`, `@subject2`, … which map onto your ordered `--reference-image` inputs — useful when a scene has several consistent characters or props.
- For a single hero shot, generating one clean character image and passing it as `--first-frame` is often enough; use references when identity must survive big motion or multiple shots.

**General structure example:** "Cinematic low-angle shot of @subject1 the fantasy warrior leaping over a chasm, high-fidelity motion, sunset backlight, sweeping pan, 1080p."

## Example prompts
```bash
# Reference-to-video: keep one character consistent across a wide cinematic shot
rtst video create vidu --prompt "@subject1 the silver-armored knight strides through a burning village at dusk, embers swirling, cloak snapping in the wind; low-angle tracking shot that sweeps into a wide reveal, high-fidelity motion, cinematic orange grade." --reference-image ./knight_front.png --reference-image ./knight_profile.png --aspect-ratio 21:9 --duration 8 --resolution 1080p --audio --wait --json
```

```bash
# First+last frame interpolation, vertical, with BGM
rtst video create vidu --prompt "Smooth transition as a paper crane unfolds into a soaring origami bird gliding over a misty mountain valley at dawn, soft volumetric light, gentle camera rise; ambient wind with a delicate piano BGM." --first-frame ./folded.png --last-frame ./flying.png --aspect-ratio 9:16 --duration 6 --resolution 1080p --audio --wait --json
```

```bash
# Text-to-video, square social format, short and punchy
rtst video create vidu --prompt "A glossy red sports car drifts around a wet neon-lit corner, spray fanning under streetlights, reflections streaking across the hood; dynamic tracking shot, high-fidelity motion, cinematic night grade." --aspect-ratio 1:1 --duration 4 --resolution 720p --audio --wait --json
```

## Limitations & tips
- **Durations are flexible (3–10s)** — the widest window of the rtst video set — but longer clips cost more and can drift; keep the action focused.
- **Widest aspect support** (including `21:9` and `9:21` ultrawide/tall) makes Vidu the go-to for cinematic banners and unusual formats.
- **Resolution nuance:** Vidu's floor is `540p`; if you request `480p` the rtst API promotes it to `540p` automatically.
- **Reference consistency is strong but not perfect** — give clean, well-lit, varied-angle references; low-quality or contradictory refs weaken identity locking. More references (up to ~7) generally help.
- **Audio/BGM is opt-in** via `--audio`; the specific "Pro / Turbo / Pro Fast" tier the rtst backend selects is not exposed as a flag.
- **Unverified:** exact reference-image cap, per-tier resolution/duration availability, and provider credit cost are governed server-side and by your account — confirm against live limits.
