# Wan 2.6 — `wan26`
**Provider:** Alibaba (Tongyi Wanxiang) · **Underlying model:** Wan 2.6 (hosted, launched Dec 2025) · **Modality:** Text-to-video + image-to-video (first frame) · **Audio:** Native, synchronized (dialogue, SFX, music) with EN/CN lip-sync

The top Wan tier: cinematic quality, native synchronized audio, multi-shot narrative control, more aspect ratios, and longer clips (up to 15s). Use it when you want a polished, self-contained shot or a short multi-beat sequence with sound.

## rtst usage
```bash
rtst video create wan26 --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `16:9`, `9:16`, `1:1`, `3:4`, `4:3`
- **Resolutions:** `720p`, `1080p`
- **Durations (s):** `5`, `10`, `15`
- **Audio:** Supported — pass `--audio` for synchronized sound
- **Image input:** `--first-frame <file>` for image-to-video (local files auto-upload). `--last-frame` / `--reference-image` are general rtst flags; per-model support on wan26 is unverified.

## How to prompt it
Audio-native and multi-shot capable, so use the full formula: **Entity + Scene + Motion + Aesthetic control + Stylization + Sound description**. Prompting carries directly over from the open Wan2.1/2.2 lineage — the visual craft is the same, with richer audio and shot control on top.

- **Visual layers:** Subject → Motion → Camera → Scene/Lighting, front-loaded (Wan weights the prompt start).
- **Camera vocabulary:** push-in, pull-out, tracking, orbit, fixed; close-up / wide / extreme full shot; center/left-heavy/right-heavy composition; daylight/firelight/overcast/rim/side light.
- **Multi-shot (a Wan 2.6 strength):** structure as *Overall description + Shot number + Timestamp + Shot content*, e.g. `[0–5s] Shot 1: ...  [5–10s] Shot 2: ...`. Keep cuts deliberate; don't over-cut a 5s clip.
- **Audio — dialogue:** quote exact lines and speaker, with emotion + tone + speed + timbre + accent. Lip-sync works in **English and Chinese**.
- **Audio — SFX/music:** source + action + ambient; music style + role.
- **Bilingual:** EN and CN both fully supported.
- **prompt_extend:** brief prompts are auto-expanded; keep intent explicit so the rewrite stays faithful.
- **Length:** ~60–120 words; more when scripting multiple shots.

## Example prompts
```bash
rtst video create wan26 --prompt "Cinematic thriller. [0-5s] Shot 1: a detective in a rain-soaked alley, neon reflections, slow push-in, she whispers \"Someone's been here\" in a tense low voice, American accent, rain hissing. [5-10s] Shot 2: wide tracking shot as she rounds the corner, thunder cracks, tense strings swell" --aspect-ratio 16:9 --duration 10 --resolution 1080p --audio --wait --json
```

```bash
rtst video create wan26 --prompt "A barista in a bright cafe latte-arts a cup, warm morning side light, medium close-up with shallow depth of field, she looks up and says \"Here you go, one flat white\" in a cheerful friendly tone; espresso machine hiss and soft indie music in the background" --aspect-ratio 9:16 --duration 5 --resolution 720p --audio --wait --json
```

```bash
# Image-to-video from a first frame, 15s
rtst video create wan26 --prompt "Bring this product photo to life: the sneaker rotates slowly on a turntable under a soft studio key light, subtle rim light catching the sole, clean white cyclorama, gentle whoosh and a light electronic beat underneath" --first-frame ./sneaker.jpg --aspect-ratio 1:1 --duration 15 --resolution 1080p --audio --wait --json
```

## Limitations & tips
- **Widest ratio support in the line** (`16:9`, `9:16`, `1:1`, `3:4`, `4:3`) but **only three durations** (`5`, `10`, `15`) and **no 480p** — minimum is 720p.
- **15s is the ceiling.** Multi-shot helps, but avoid cramming a full 30s story arc into one generation.
- Lip-sync is strongest with short quoted lines; exact on-screen text and named real people remain weak spots.
- Wan 2.6 launched December 2025 and the 2.5/2.6/2.7 line is fast-moving with overlapping public naming (some sources label similar capabilities "2.7"). Treat `wan26` as Wan 2.6 per rtst; some behaviors are hard to verify and the backend build may change. Test at 720p before committing to 1080p + audio.
