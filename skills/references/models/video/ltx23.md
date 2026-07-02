# LTX-2 Pro — `ltx23`

**Provider:** Lightricks (served via ModelsLab) · **Underlying model:** LTX-2 Pro
(LTX-2 audio–video DiT) · **Modality:** text-to-video and image-to-video
(first frame) · **Audio:** yes (native, synchronized audio in the same model)

LTX-2 is the first DiT-based foundation model that generates synchronized video
*and* audio together — dialogue, singing, ambient sound, and music — with a
real-time-oriented pipeline for fast iteration and production-grade, high-res
output. Reach for it when you want native audio at high resolution (up to 4K) on a
cinematic 16:9 canvas. Note it is **16:9 only** in rtst.

## rtst usage

```bash
rtst video create <name> --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)

- **Aspect ratios:** `16:9` only (fixed)
- **Resolutions:** `1080p`, `1440p` (2K), `2160p` (4K)
- **Durations (s):** `6`, `8`, `10`
- **Audio:** yes — native audio generation, enable with `--audio`
- **Image input:** `--first-frame <file>` for image-to-video (animate from a
  starting frame). Local files auto-upload.

## How to prompt it

LTX-2 reads prompts as **narrative**, not structured data. Write a single flowing
paragraph in **present tense** — roughly 4–8 sentences, scaled to duration (a 6s
clip needs fewer; a 10s clip needs more).

- **One paragraph, present tense.** No bullet lists or fragmented commands; avoid
  past tense and imperatives.
- **Physical cues, not emotion labels.** Instead of "she is sad," write "her eyes
  lower and her jaw tightens." The model animates what it can see.
- **Camera end-states.** Specify where motion lands: not "the camera pushes in" but
  "the camera pushes in slowly, settling on a close-up of her face" — this lets the
  model complete moves cleanly. It understands tracking, panning, zooming, static.
- **Audio in-line.** Put spoken words in quotation marks inside the description and
  give the voice a physical quality: "a resonant voice with gravitas," "she
  whispers," "an energetic announcer." Ambient sound and music can be named too.
- **Image-to-video (first frame):** describe **motion and action only** — don't
  re-describe what's already visible in the source image.

## Example prompts

```bash
# 1. Cinematic T2V with native audio, 4K
rtst video create harbor-dawn --prompt "At first light a fishing boat glides into a quiet harbor as gulls wheel overhead and water laps against the hull; the camera tracks alongside the deck, then pushes in slowly and settles on the weathered captain at the wheel, his eyes narrowing against the wind. Ambient sound of creaking rope and distant bells fills the air." --aspect-ratio 16:9 --duration 10 --resolution 2160p --audio --wait --json

# 2. Dialogue-driven scene, 2K
rtst video create pitch-room --prompt "In a sunlit conference room a founder stands and turns toward the table, her posture straightening as the camera pushes in and settles on a medium close-up. In a warm, confident voice she says, \"This is the part everyone told us was impossible.\" Soft room tone and the faint hum of a projector underscore the moment." --aspect-ratio 16:9 --duration 8 --resolution 1440p --audio --wait --json

# 3. Image-to-video from a first frame, 1080p
rtst video create forest-wake --prompt "The morning mist begins to drift between the trees as shafts of light sweep across the clearing; a deer lifts its head and steps forward, and the camera slowly cranes up to reveal the ridgeline beyond. Birdsong rises gently in the background." --first-frame ./forest.png --aspect-ratio 16:9 --duration 6 --resolution 1080p --audio --wait --json
```

## Limitations & tips

- **16:9 only in rtst.** LTX-2 open-source docs advertise more aspect ratios
  (9:16, 21:9, 1:1, etc.), but the rtst API enforces 16:9 — the other ratios are
  not exposed here.
- **Durations are fixed at 6/8/10s** in rtst even though the underlying model can
  do other lengths; use these exact values.
- **Text and logos** render unreliably — supply them via the first frame.
- **Complex multi-body physics** and overloaded scenes (too many characters) tend
  to break down; keep the main action clear.
- Match prompt length to duration and lead with the strongest visual/audio beat.
- LTX-2 versioning is fast-moving (the model family spans LTX-2 / LTX-2.3);
  capability details vary across sources, so confirm enforced parameters with
  `rtst model get ltx23 --json`.
