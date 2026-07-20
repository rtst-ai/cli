# Seedance 2.0 Fast — `seedance20fast`
**Provider:** BytePlus ModelArk (ByteDance Seed) · **Underlying model:** Seedance 2.0 Fast · **Modality:** Text-to-video & image-to-video (first + last frame, reference images) · **Audio:** Yes (native audio-video joint generation, multilingual lip-sync)

The speed/cost-optimized variant of the Seedance 2.0 family: the same 2.0 prompt adherence, native multi-shot, and native audio, but capped at 720p for faster, cheaper renders. Use it for iteration, social-format content, and high-volume work; step up to `seedance20` when you need 1080p/4K, or `seedance20mini` for the cheapest tier.

## rtst usage
```bash
rtst video create seedance20fast --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `21:9`, `16:9`, `4:3`, `1:1`, `3:4`, `9:16`
- **Resolutions:** `480p`, `720p` (no 1080p / 4K)
- **Durations (s):** `4`–`15` (any integer in range)
- **Audio:** Yes — enable with `--audio`
- **Image input:** `--first-frame <file>`, `--last-frame <file>` (frame interpolation), `--reference-image <file>` (repeatable, up to 9). Inputs may be local files, URLs, or existing photo ids; this model takes **photo ids, not URLs**, so the CLI uploads each input as a Photo automatically.
- **Prompt placeholders (required for references):** mention each reference in the prompt — `{{img1}}`, `{{img2}}`, ... for `--reference-image` order; `{{first}}`/`{{last}}` for the frame flags. Unmentioned references anchor nothing. Content-moderated (public figures rejected).

## How to prompt it
Prompt it exactly like the flagship `seedance20` — it shares the same architecture and prompt understanding. Use the 6-step formula, ~60–100 words:

**Subject → Action → Environment → Camera → Style → Constraints**

- **Subject / Action:** concrete subject + one clear present-tense verb.
- **Environment:** location, time, weather, atmosphere.
- **Camera:** ONE primary move from the 8 Seedance types — Push-in (`dolly in`), Pull-out (`dolly out`, `reveal wide`), Pan (`lateral sweep`), Tracking (`follow shot`), Orbit (`arc around`), Aerial (`drone shot`), Handheld (`natural shake`), Fixed (`locked-off`).
- **Style:** lead with lighting (the strongest quality lever), then lens, color/film reference, and mood.
- **Constraints:** what to avoid.

It supports **native multi-shot** (describe successive shots in one prompt; identity and lighting carry across cuts) and **native audio** via `--audio` (ambient sound, music mood, and lip-synced dialogue in 8+ languages). Keep camera movement separate from subject movement, use pacing words (`slow`, `smooth`, `gentle`) rather than speed numbers, and favor concrete description over vague adjectives.

Because output is capped at 720p, this model is ideal for prompt exploration: dial in the shot cheaply here, then re-run the finished prompt on `seedance20` for a 1080p/4K master if needed.

## Example prompts
```bash
rtst video create seedance20fast --prompt "A barista pours steamed milk into a latte, forming a leaf pattern, in a sunlit corner cafe. Slow dolly in on the cup. Warm morning window light, shallow depth of field, cozy natural color, quiet ambient chatter." --aspect-ratio 9:16 --duration 6 --resolution 720p --audio --wait --json
```

```bash
rtst video create seedance20fast --prompt "A golden retriever bounds across a wet beach at sunset, kicking up spray. Camera tracks alongside at a steady jog. Backlit golden-hour light, wide lens, warm cinematic color, playful energetic mood." --aspect-ratio 16:9 --duration 8 --resolution 720p --wait --json
```

```bash
rtst video create seedance20fast --prompt "Animate this sneaker product shot: the shoe slowly rotates on a matte pedestal as studio light sweeps across it. Camera holds a locked-off medium shot. Clean high-key lighting, crisp detail, neutral color, premium ad feel." --first-frame ./sneaker.jpg --aspect-ratio 1:1 --duration 5 --resolution 720p --wait --json
```

## Limitations & tips
- **720p maximum in rtst** — there is no 1080p or 4K path on this model. For a higher-resolution master, re-run the same prompt on `seedance20`.
- One primary camera move per prompt; multiple moves cause jitter. Use "locked-off"/`--camerafixed` wording for static shots.
- Clips of 12–15s raise the risk of temporal flicker and identity drift; keep multi-shot sequences short (2–4 shots) and restate subject details at each cut.
- BytePlus does not publish an exact multi-shot/audio prompt *syntax*; drive both with natural-language shot descriptions plus `--audio`.
- Always include a lighting description — it has the biggest impact on quality.
