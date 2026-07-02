# Kling 2.6 — `kling26`

**Provider:** Kuaishou (Kling AI) · **Underlying model:** Kling Video 2.6 ·
**Modality:** text-to-video and image-to-video (first + last frame) ·
**Audio:** yes (native audio)

Kling 2.6 is the fast, cost-efficient tier of the Kling line: dependable motion
and native audio at fixed 5s or 10s lengths and up to 1080p. Reach for it for
quick iteration and social-format clips; step up to `kling3` when you need
3–15s flexibility, 4K, or multi-shot storyboards, or `kling3omni` for
reference/voice control.

## rtst usage

```bash
rtst video create <name> --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)

- **Aspect ratios:** `16:9`, `9:16`, `1:1`
- **Resolutions:** `720p`, `1080p`
- **Durations (s):** `5`, `10` (only these two values)
- **Audio:** yes — enable with `--audio`
- **Image input:** `--first-frame <file>` and/or `--last-frame <file>` for
  image-to-video / start-end interpolation. Local files auto-upload.

## How to prompt it

The Kling prompt conventions carry over from 3.0. Write directorial prompts in the
order **camera → scene → subject + action → mood/lighting → audio.**

- **Camera vocabulary:** `tracking shot`, `dolly in/out`, `pan`, `crane shot`,
  `static tripod shot`, `POV`, `macro close-up`, `profile shot`. Use
  `static tripod shot` when you want only the subject to move.
- **Be specific about motion** — name both subject action and camera behavior; keep
  a single dominant action per clip since durations are short (5s or 10s).
- **Audio / dialogue:** with `--audio`, attach lines to a named speaker with a tone,
  e.g. `[Leo, cheerful voice]: "Over here!"`. Avoid pronouns.
- **Image-to-video:** anchor on the first frame and describe how the scene evolves;
  add `--last-frame` to steer the closing composition.
- **Keep it single-shot.** 2.6 is not built for six-shot storyboards — one clear
  scene per generation reads best.

## Example prompts

```bash
# 1. Fast social clip, vertical, 5s
rtst video create street-food --prompt "Handheld tracking shot following a chef flipping noodles in a wok over roaring flame at a night market, steam and sparks rising, warm neon reflections, sizzling ambient sound" --aspect-ratio 9:16 --duration 5 --resolution 1080p --audio --wait --json

# 2. Image-to-video, 10s horizontal
rtst video create lake-morning --prompt "Slow dolly in across the misty lake as ripples spread and a heron lifts off, soft dawn light warming the water, gentle camera settling on the distant shore" --first-frame ./lake.png --aspect-ratio 16:9 --duration 10 --resolution 1080p --wait --json

# 3. Static portrait with dialogue
rtst video create piece-to-camera --prompt "Static tripod shot, medium close-up of Nadia in a bright home office, soft window light. [Nadia, warm confident voice]: \"Here's what changed everything for me this year.\"" --aspect-ratio 1:1 --duration 10 --resolution 720p --audio --wait --json
```

## Limitations & tips

- **Only 5s and 10s** durations — no in-between; plan pacing accordingly.
- **1080p ceiling** — no 4K here; use `kling3` if you need 2160p.
- **Single dominant action** per clip; complex multi-body physics and dense crowds
  can drift within the short window.
- **In-frame text/logos** are unreliable — supply them via a first-frame image.
- Enforced parameters above are ground truth; re-check with
  `rtst model get kling26 --json`.
