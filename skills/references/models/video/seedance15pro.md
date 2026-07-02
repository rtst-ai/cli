# Seedance 1.5 Pro — `seedance15pro`
**Provider:** BytePlus ModelArk (ByteDance Seed) · **Underlying model:** Seedance 1.5 Pro · **Modality:** Text-to-video & image-to-video (first + last frame, reference images) · **Audio:** Yes (via `--audio`)

The previous-generation Seedance model. It produces strong cinematic motion and multi-shot narratives, but treats camera instructions more as a suggestion than a command — the 2.0 family (`seedance20`, `seedance20fast`, `seedance20mini`) is more literal about camera and holds identity better across cuts. Reach for 1.5 Pro when you specifically want this model's look or an existing pipeline targets it.

## rtst usage
```bash
rtst video create seedance15pro --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `9:16`, `16:9`, `4:3`, `1:1`, `3:4`
- **Resolutions:** `480p`, `720p` (rtst caps this model at 720p)
- **Durations (s):** `4`, `5`, `6`, `8`, `10`, `12` (discrete set — not a continuous range)
- **Audio:** Yes — enable with `--audio`
- **Image input:** `--first-frame <file>`, `--last-frame <file>` (start/end-frame control), `--reference-image <file>` (repeatable). Local files auto-upload; URLs also accepted.

## How to prompt it
Seedance 1.5 Pro reads best as a **shot description**. Its core formula is:

**[Subject] + [Motion]**, optionally combined with **[Background] + [Motion]** and **[Camera] + [Motion]**

Order matters: state composition/shot size first, then the main subject, then camera movement, then overall mood. This ordering lets the model "lock" the frame before it invents motion, reducing contradictions. Example structure: *"Wide shot of a foggy forest path… low-angle tracking shot moving toward the doorway… cinematic, moody."*

- **Camera movements it responds to:** `push`, `pull`, `pan`, `move`, `circle around`, `follow`, `rise`, `zoom`. You can combine moves for longer creative shots, but keep them coherent.
- **Motion intensity:** control speed with adverbs (`slowly`, `rapidly`, `gently`, `smoothly`).
- **Multi-action / storytelling:** describe actions in timeline order using `first`, `then`, `after`, `finally` — the more precise the progression, the smoother the pacing.
- **Audio:** pass `--audio` and describe intended sound/mood in the prompt; 1.5 Pro supports native audio and multilingual lip-sync.
- **First/last frame:** supply `--first-frame` (and optionally `--last-frame`) for image-to-video or start→end interpolation; describe the motion that bridges the frames.

Because 1.5 Pro follows camera cues loosely, favor simple, clear language and lead with a lighting description (the highest-impact quality lever) rather than stacking technical camera jargon.

## Example prompts
```bash
rtst video create seedance15pro --prompt "Wide shot of a foggy forest path at dawn. A lone hiker in a red jacket walks slowly away from camera as the camera pushes forward through the mist. Soft diffused light, muted cinematic color, calm and mysterious mood." --aspect-ratio 16:9 --duration 8 --resolution 720p --wait --json
```

```bash
rtst video create seedance15pro --prompt "Close-up of a perfume bottle on a pastel table. The camera circles around the table, slowly orbiting the scene; first sunlight pours in, then reflections shimmer across the surface. Elegant, fluid, cinematic." --aspect-ratio 9:16 --duration 6 --resolution 720p --audio --wait --json
```

```bash
rtst video create seedance15pro --prompt "Animate this photo: a city skyline at dusk. Clouds drift across the sky and window lights gradually switch on as the camera slowly rises above the rooftops. Warm ambient glow, wide framing, serene tone." --first-frame ./skyline.jpg --aspect-ratio 16:9 --duration 10 --resolution 720p --wait --json
```

## Limitations & tips
- **Older generation.** Camera adherence is looser than the 2.0 family, and identity can drift across long multi-shot sequences — keep sequences short and restate subject details. For strict camera control, native 4K, or best-in-class consistency, use `seedance20`.
- **Durations are a fixed set** — `4, 5, 6, 8, 10, 12`. Values like `7`, `9`, or `11` are not valid; `15` is 2.0-family only.
- **720p max in rtst.** (Some public write-ups mention 1080p for Seedance 1.5 Pro elsewhere; the rtst API caps this model at 720p — use `seedance20` for 1080p/4K.)
- One coherent camera intent per shot; over-stacking moves produces shaky output. Use adverbs for pacing.
- Always include a lighting description — it has the biggest impact on quality.
