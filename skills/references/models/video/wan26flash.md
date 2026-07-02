# Wan 2.6 Flash — `wan26flash`
**Provider:** Alibaba (Tongyi Wanxiang) · **Underlying model:** Wan 2.6 Flash (hosted, faster/cheaper variant) · **Modality:** Text-to-video (no separate image-frame slot) · **Audio:** Native, synchronized (dialogue, SFX, music)

The fast, low-cost member of the Wan 2.6 lineup. Flash trades some fidelity for shorter inference time and lower per-second cost, optimized for high-volume, iterative text-to-video — A/B testing ad hooks, rapid concepting, batch generation. Audio and multi-shot control carry over; the dedicated first-frame image path does not.

## rtst usage
```bash
rtst video create wan26flash --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `16:9`, `9:16`, `1:1`, `3:4`, `4:3`
- **Resolutions:** `720p`, `1080p`
- **Durations (s):** `5`, `10`, `15`
- **Audio:** Supported — pass `--audio` for synchronized sound
- **Image input:** Text-to-video focus — **no separate first-frame slot** on this variant. Use `wan26` when you need image-to-video from a still. (`--last-frame` / `--reference-image` are general rtst flags; support on `wan26flash` is unverified.)

## How to prompt it
Prompt it like `wan26` — the craft transfers directly from the open Wan2.1/2.2 lineage — but write **self-contained text prompts** since there is no reference frame to lean on. Describe the subject fully; Flash has less headroom to invent missing detail cleanly.

- **Formula:** Entity + Scene + Motion + Aesthetic control + Stylization + Sound description.
- **Layers:** Subject → Motion → Camera → Scene/Lighting, front-loaded (Wan weights the prompt start).
- **Be explicit on the subject:** 2+ distinguishing features; vague subjects degrade more on a fast model.
- **Camera:** one clear shot type per beat (push-in, pull-out, tracking, orbit, fixed); pick a lighting style (soft/hard/rim/side, daylight/dusk/night).
- **Multi-shot:** *Overall description + Shot number + Timestamp + Shot content* is supported; keep it simple on Flash.
- **Audio — dialogue:** quote exact lines + speaker + emotion/tone/speed/timbre/accent; EN and CN lip-sync.
- **Bilingual:** English and Chinese both supported.
- **prompt_extend:** brief prompts auto-expand; because Flash is cheap, iterate quickly rather than over-engineering one prompt.
- **Length:** ~40–100 words; leaner than full Wan 2.6 is fine.

## Example prompts
```bash
rtst video create wan26flash --prompt "A young man in a yellow raincoat splashes through puddles on a neon-lit city street at night, tracking shot moving with him, reflections shimmering, upbeat synth music and splashing footsteps, energetic mood" --aspect-ratio 9:16 --duration 5 --resolution 720p --audio --wait --json
```

```bash
rtst video create wan26flash --prompt "Product hook: a frosty can of citrus soda on a marble counter with condensation dripping, slow orbit around the can, bright studio key light with sharp rim light, crisp fizz and pop sound with a punchy electronic beat" --aspect-ratio 1:1 --duration 5 --resolution 1080p --audio --wait --json
```

```bash
rtst video create wan26flash --prompt "A golden retriever sprints across a sunlit meadow toward the camera, ears flapping, slow-motion feel, wide shot with shallow depth of field, warm golden hour light, joyful panting and light acoustic guitar underneath" --aspect-ratio 16:9 --duration 10 --resolution 720p --audio --wait --json
```

## Limitations & tips
- **No dedicated first-frame image input.** For image-to-video, switch to `wan26`.
- **Lower fidelity than full Wan 2.6** — expect softer detail and less reliable fine motion; ideal for volume and iteration, not hero finals.
- Same envelope as Wan 2.6: ratios `16:9/9:16/1:1/3:4/4:3`, resolutions `720p/1080p`, durations `5/10/15`, 720p minimum (no 480p).
- Lip-sync to exact words, legible on-screen text, and named real people remain weak spots.
- Wan 2.6 Flash is part of a fast-moving 2.5/2.6/2.7 line with overlapping public naming; some capabilities are hard to verify and the backend build may change. Because Flash is cheap, prefer a quick 720p test pass and iterate.
