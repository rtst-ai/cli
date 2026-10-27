# Seedance 2.0 Mini — `seedance20mini`
**Provider:** BytePlus ModelArk (ByteDance Seed) · **Underlying model:** Seedance 2.0 Mini · **Modality:** Text-to-video & image-to-video (first + last frame, reference images) · **Audio:** Yes (native audio-video joint generation, multilingual lip-sync)

The cheapest member of the Seedance 2.0 family: the same 2.0-generation prompt understanding and native audio, at 720p max and the lowest cost per render. Use it for bulk generation, drafts, and cost-sensitive pipelines; move to `seedance20fast` for a faster 720p tier or `seedance20` when you need 1080p/4K quality.

## rtst usage
```bash
rtst video create seedance20mini --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `21:9`, `16:9`, `4:3`, `1:1`, `3:4`, `9:16`
- **Resolutions:** `480p`, `720p` (no 1080p / 4K)
- **Durations (s):** `4`–`15` (any integer in range)
- **Audio:** Yes — enable with `--audio`
- **Image input:** `--first-frame <file>`, `--last-frame <file>` (frame interpolation), `--reference-image <file>` (repeatable, up to 9). Inputs may be local files, URLs, or existing photo ids; this model takes **photo ids, not URLs**, so the CLI uploads each input as a Photo automatically.
- **Prompt placeholders (required for references):** mention each reference in the prompt — `{{img1}}`, `{{img2}}`, ... for `--reference-image` order; `{{first}}`/`{{last}}` for the frame flags (written as plain words — the frame is already set by the flag). **Use frames OR reference images in one job, not both** (the provider rejects the mix; the CLI stops you first). Unmentioned references anchor nothing. Content-moderated (public figures rejected).
- **Video & audio references:** `--reference-video <file>` and `--reference-audio <file>` (each repeatable, up to 3; local files, URLs, or existing ids), cited as `{{vid1}}`, `{{aud1}}`, ... E.g. `"the dancer from {{img1}} moves to the beat of {{aud1}}"`. Per-file and total duration limits are in `rtst model get <model> --json` → `image_capabilities.reference_videos` / `reference_audios` (defaults: 2 to 15 s each, 15 s total). Reference audio turns on `--audio` automatically. Like images, these cannot be combined with `--first-frame`/`--last-frame`.

## How to prompt it
Prompt it the same way as the rest of the 2.0 family. Use the BytePlus 6-step formula, ~60–100 words:

**Subject → Action → Environment → Camera → Style → Constraints**

- **Subject / Action:** a concrete subject and one clear present-tense verb for the main motion.
- **Environment:** setting, time of day, weather, atmosphere.
- **Camera:** exactly ONE primary move — Push-in (`dolly in`), Pull-out (`dolly out`, `reveal wide`), Pan (`lateral sweep`), Tracking (`follow shot`), Orbit (`arc around`), Aerial (`drone shot`), Handheld (`natural shake`), or Fixed (`locked-off`).
- **Style:** lighting first (strongest quality lever), then lens, color/film reference, mood.
- **Constraints:** what to avoid.

It supports **native multi-shot** (describe successive shots in one prompt) and **native audio** via `--audio` (ambient sound, music mood, lip-synced dialogue in 8+ languages). As with all Seedance models, separate camera movement from subject movement, use pacing words (`slow`, `smooth`, `gentle`) rather than speed numbers, and prefer concrete detail over vague adjectives.

Being the lowest-cost tier, Mini is the natural place to run many prompt variations or storyboard drafts cheaply, then promote the best result to `seedance20fast` (720p) or `seedance20` (1080p/4K).

## Example prompts
```bash
rtst video create seedance20mini --prompt "A street vendor flips sizzling noodles in a wok over open flame at a night market, sparks rising. Camera holds a steady medium shot. Warm firelight against neon signage, wide lens, rich saturated color, lively market ambience." --aspect-ratio 9:16 --duration 5 --resolution 720p --audio --wait --json
```

```bash
rtst video create seedance20mini --prompt "A paper boat drifts down a rain-swollen gutter past autumn leaves. Camera tracks slowly alongside the boat at water level. Overcast soft light, shallow focus, muted melancholic color, gentle handheld feel." --aspect-ratio 16:9 --duration 8 --resolution 720p --wait --json
```

```bash
rtst video create seedance20mini --prompt "Animate this landscape photo: mist rolls across the valley as the sun rises and birds cross the frame. Camera slowly pushes forward over the ridge. Golden dawn light, wide lens, natural warm color, serene mood." --first-frame ./valley.jpg --aspect-ratio 16:9 --duration 6 --resolution 720p --wait --json
```

## Limitations & tips
- **720p maximum in rtst** — no 1080p or 4K. Being the smallest/cheapest model, expect slightly lower fine detail and motion fidelity than `seedance20fast` or `seedance20`; use it for drafts and volume, then re-run winners on a higher tier.
- One primary camera move per prompt; multiple moves cause jitter. Use "locked-off"/`--camerafixed` wording for static shots.
- 12–15s clips increase temporal flicker and identity-drift risk; keep multi-shot sequences short and restate subject details at each cut.
- BytePlus does not publish an exact multi-shot/audio prompt *syntax*; use natural-language shot descriptions plus `--audio`.
- Always include a lighting description — it has the biggest impact on quality.
