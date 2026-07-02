# Google Veo 3 — `veo3`
**Provider:** Google DeepMind (via Vertex AI) · **Underlying model:** `veo-3.0-fast-generate-001` · **Modality:** Text-to-video & image-to-video · **Audio:** Native (dialogue, SFX, ambient, music)

Veo 3 is Google's flagship cinematic generator whose signature feature is **synchronized native audio** — spoken dialogue with lip-sync, timed sound effects, and ambient beds generated straight from the prompt. Reach for it when a clip needs sound and film-grade motion in one pass.

## rtst usage
```bash
rtst video create veo3 --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `16:9`, `9:16`
- **Resolutions:** `720p`, `1080p`
- **Durations (s):** `4`, `6`, `8`
- **Audio:** Yes — enable with `--audio` (off by default). Cue dialogue/SFX/ambient inside the prompt.
- **Image input:** Single start image via `--first-frame <file>` (image-to-video). No `--last-frame` slot and no separate reference-image slot on this model. Local files auto-upload; URLs pass through.
- **Person policy:** The API exposes a `personGeneration` safety setting (`allow_all`, `allow_adult`, `dont_allow`) governing whether/what people the model may render; `allow_adult` is Google's documented default. Some regions restrict people in image-to-video regardless of the flag.

## How to prompt it
Veo 3 rewards dense, director-style prompts. Google's guide frames the ideal prompt as ~3–6 sentences (≈100–150 words) built from seven layers: **shot framing & motion → style → lighting → character detail → location → action → dialogue/audio**. A practical formula: `[Cinematography] + [Subject] + [Action] + [Setting] + [Style/Mood] + [Audio]`.

- **Speak the camera's language.** Use real film terms — *dolly in, tracking shot, crane shot, slow pan, POV, low-angle, wide shot, close-up, extreme close-up, shallow depth of field, macro lens*. Specificity here directly controls framing.
- **Be concrete about subjects.** "A woman in her twenties with wavy brown hair and light freckles" beats "a woman." Detail is control.
- **Author the audio explicitly.** Put dialogue in quotes: `She says, "We have to leave now."` Label other sound: `SFX: thunder cracks in the distance` and `Ambient: quiet hum of a starship bridge`. Keep spoken lines short enough to land inside the clip's few seconds.
- **Sensory world-building.** Evocative environmental detail (weather, textures, light quality) grounds the scene and improves coherence.
- **Negatives as descriptions, not bans.** Prefer "a desolate landscape with no buildings" over "no man-made structures" — describe the desired absence.

## Example prompts
```bash
# Text-to-video with dialogue + ambient audio
rtst video create veo3 --prompt "Medium close-up, a weathered lighthouse keeper in a yellow slicker grips the railing as storm spray lashes the lens, slow push-in, moody blue-hour lighting, film grain. He mutters, \"She won't hold much longer.\" Ambient: howling wind and crashing surf, SFX: a distant foghorn." --aspect-ratio 16:9 --duration 8 --resolution 1080p --audio --wait --json
```

```bash
# Vertical clip, fast motion choreographed play-by-play
rtst video create veo3 --prompt "Low-angle tracking shot chasing a parkour runner leaping between rooftop gaps at golden hour, camera whips to follow each vault, cinematic teal-and-orange grade, shallow depth of field, dust kicking up on landing." --aspect-ratio 9:16 --duration 6 --resolution 720p --audio --wait --json
```

```bash
# Image-to-video: animate a supplied first frame
rtst video create veo3 --prompt "The still portrait comes alive: the subject slowly turns toward camera and smiles as warm window light shifts across her face, subtle hair movement, gentle handheld drift." --first-frame ./portrait.png --aspect-ratio 9:16 --duration 4 --resolution 1080p --wait --json
```

## Limitations & tips
- **Clips are short (4/6/8 s).** Write dialogue that fits one or two breaths; long monologues get truncated or rushed.
- **Audio is opt-in** via `--audio`. Without it you get a silent video even if the prompt describes sound.
- **Only two aspect ratios** (16:9 / 9:16) on this model — no square or ultrawide.
- **Image-to-video is first-frame only.** For start+end interpolation or multi-reference character consistency, use `veo31` (which adds last-frame and reference-image support) or `vidu`.
- **People/identity:** the `personGeneration` policy plus regional rules can block or alter human generation; realistic depiction of real, named individuals is disallowed.
- All Veo outputs carry Google's invisible **SynthID** watermark marking them AI-generated.
- **Unverified:** exact provider-side credit cost and the precise regional person-generation matrix are not enforced in the rtst client — confirm against your account limits.
