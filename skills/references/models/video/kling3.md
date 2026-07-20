# Kling 3.0 — `kling3`

**Provider:** Kuaishou (Kling AI) · **Underlying model:** Kling Video 3.0 ·
**Modality:** text-to-video and image-to-video (first + last frame) ·
**Audio:** yes (native dialogue, ambient, SFX)

Kling 3.0 is a cinematic video model that thinks in *shots, not clips*: it handles
explicit camera direction, multi-shot storyboards (up to six shots in one output),
and native synchronized audio. Reach for it when you want directable, film-grade
motion up to 15 seconds and optional 4K output. For richer reference/video-driven
inputs use `kling3omni`; for a cheaper 5s/10s workflow use `kling26`.

## rtst usage

```bash
rtst video create <name> --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)

- **Aspect ratios:** `16:9`, `9:16`, `1:1`
- **Resolutions:** `720p`, `1080p`, `2160p` (4K)
- **Durations (s):** `3`–`15`
- **Audio:** yes — enable with `--audio`
- **Image input:** `--first-frame <file>` and/or `--last-frame <file>` for
  image-to-video / start-end interpolation, plus one `--reference-image` (max 1).
  Inputs may be local files, URLs, or existing photo ids; this model takes
  **photo ids, not URLs**, so the CLI uploads each input as a Photo automatically.
- **Prompt placeholders:** refer to the reference in the prompt as `{{img1}}`
  (`{{first}}`/`{{last}}` for the frame flags), e.g. `"the product from {{img1}}
  rotating on a turntable"`. An unmentioned reference anchors nothing.
  Content-moderated (public figures rejected).

## How to prompt it

Kling 3.0 rewards *directorial* prompts written in shot order. A reliable formula:

> **Camera movement → scene setup → subject + action → mood/lighting → time/audio.**

- **Camera vocabulary it understands:** `tracking shot`, `dolly in/out`,
  `drone flyover`, `crane shot`, `static tripod shot`, `pan left/right`,
  `profile shot`, `macro close-up`, `POV`, `shot-reverse-shot`, `long take`.
  A `static tripod shot` freezes the camera so only the subject animates.
- **Be explicit about motion.** Specify both subject motion and camera behavior
  (tracking, following, freezing, syncing) rather than vague phrasing.
- **Multi-shot / storyboard:** describe each shot as a labeled beat instead of
  cramming everything into one sentence. Give each shot its framing, subject, and
  motion, and keep a consistent name for each character across shots.
- **Audio / dialogue:** with `--audio`, say who speaks and when. Bind lines to a
  named character and a tone, e.g. `[Anna, hesitant voice]: "Are you sure?"`.
  Avoid pronouns — use consistent labels so the model knows who is talking.
- **Image-to-video:** treat the first frame as an anchor and describe how the
  scene *evolves* (motion, camera) rather than re-describing what's already visible.
  Add `--last-frame` to control the ending pose/composition.

## Example prompts

```bash
# 1. Single cinematic shot, 4K, horizontal
rtst video create canyon-drone --prompt "Drone flyover descending toward a lone hiker standing on a red-rock canyon rim at golden hour, warm rim light, dust drifting, camera slowly pushing in to a mid shot as she turns to face the valley" --aspect-ratio 16:9 --duration 10 --resolution 2160p --wait --json

# 2. Multi-shot storyboard with dialogue, vertical, native audio
rtst video create diner-scene --prompt "Shot 1, static tripod shot, medium close-up of Mara in a neon-lit diner booth, rain on the window. [Mara, weary voice]: \"You actually came.\" Shot 2, shot-reverse-shot on Ken sliding into the seat opposite, warm practical lights. [Ken, low steady voice]: \"I said I would.\"" --aspect-ratio 9:16 --duration 12 --resolution 1080p --audio --wait --json

# 3. Image-to-video with start and end frame
rtst video create logo-reveal --prompt "The camera pushes in slowly as the metal emblem catches a sweep of light and rotates, settling on a centered hero close-up, subtle particles rising" --first-frame ./start.png --last-frame ./end.png --aspect-ratio 1:1 --duration 6 --resolution 1080p --wait --json
```

## Limitations & tips

- **Duration vs. cost/resolution:** 15s at 2160p is the most expensive combination;
  drop to 1080p or shorter durations for faster iteration.
- **Multi-character audio** works best when every speaker has a unique, consistent
  label and an explicit tone/emotion; ambiguous pronouns cause voice mix-ups.
- **Text and small logos** in-frame remain unreliable across most video models —
  prefer supplying them via a first-frame image.
- **Complex multi-body physics** and dense crowds can drift; keep the primary
  action readable and let secondary motion be atmospheric.
- Ground-truth parameters above are what the rtst API enforces. Kling's public
  docs sometimes cap web-UI output at 1080p; rtst exposes 2160p — verify a live
  4K job if quality-critical. Re-check with `rtst model get kling3 --json`.
