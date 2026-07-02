# Wan 2.2 — `wan22`
**Provider:** Alibaba (Tongyi Wanxiang) · **Underlying model:** Wan 2.2 (open-source lineage, MoE A14B DiT) · **Modality:** Text-to-video + image-to-video (first frame) · **Audio:** None (silent output)

The free/budget tier of the Wan family. Wan 2.2 is a strong, fast diffusion model with an open-weight lineage (Wan2.1/2.2 shipped under Apache 2.0), good motion and camera control, but no native audio. Reach for it when you want quick, cheap 5-second clips and will add sound in post.

## rtst usage
```bash
rtst video create wan22 --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `9:16`, `16:9`, `1:1`
- **Resolutions:** `480p`, `1080p`
- **Durations (s):** `5` only
- **Audio:** Not supported — do not pass `--audio`
- **Image input:** `--first-frame <file>` for image-to-video (local files auto-upload). `--last-frame` / `--reference-image` are general rtst flags; per-model support on wan22 is unverified.

## How to prompt it
Wan responds best to the official formula: **Entity + Scene + Motion**, optionally extended with **Aesthetic control + Stylization**. Order matters — Wan front-weights the start of the prompt, so lead with your subject and its most important action.

- **Structure the prompt in layers:** Subject → Motion → Camera → Scene/Lighting.
- **Subject:** give 2+ distinguishing visual features ("woman with short silver hair and round glasses"), never "a person".
- **Motion:** use Speed + Direction + Body mechanics ("walks slowly toward the camera, left hand running through her hair, then stops and tilts her head right"). Avoid bare verbs like "dancing".
- **Camera:** one clear shot per clip — "slow push-in, shallow depth of field, medium close-up". Do not combine contradictory shots (no "drone shot" + "extreme close-up").
- **Scene/Lighting:** add 2+ environmental details and mood lighting ("golden hour with long shadows", "neon reflections on wet pavement").
- **Length:** aim for ~25–80 words. Under-specify and the model invents its own defaults.
- **Bilingual:** English and Chinese prompts both work well.
- **prompt_extend / rewrite:** Wan supports automatic prompt expansion; keep intent clear so the rewrite stays on-message.
- **Negative prompts** (where the backend accepts them): "blurry, low quality, distorted face, bad anatomy, extra limbs, morphing, watermark, text".

## Example prompts
```bash
rtst video create wan22 --prompt "A fluffy orange tabby with a white chest patch stalks slowly across a sunlit wooden floor, tail low, then pounces on a rolling ball of yarn, slow push-in, warm golden hour light" --aspect-ratio 16:9 --duration 5 --resolution 1080p --wait --json
```

```bash
rtst video create wan22 --prompt "A woman with short silver hair and round glasses walks briskly toward the camera through falling snow at dusk, breath visible, medium shot with shallow depth of field, cool blue rim light" --aspect-ratio 9:16 --duration 5 --resolution 1080p --wait --json
```

```bash
# Image-to-video: animate a still as the first frame
rtst video create wan22 --prompt "Animate this landscape with slow drifting clouds and gently swaying grass, subtle handheld camera drift, soft overcast daylight" --first-frame ./landscape.jpg --aspect-ratio 16:9 --duration 5 --resolution 480p --wait --json
```

## Limitations & tips
- **No audio.** Output is silent; add music/SFX/dialogue in a later step.
- **5 seconds only.** Do not script 15–30s choreography into one prompt; it will be compressed or ignored. Keep to one beat of action.
- **Two resolutions only** (480p, 1080p) — there is no 720p on this tier. Use 480p for cheap test iterations, 1080p for finals.
- Avoid rapid scene changes, named real people, and legible on-screen text — all are weak spots across the Wan line.
- The Wan 2.x/2.6 line is fast-moving with overlapping public naming; exact backend build behind `wan22` may drift, so treat prompt behavior as guidance, not a contract. Test with a cheap 480p pass first.
