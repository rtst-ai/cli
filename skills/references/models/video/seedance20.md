# Seedance 2.0 — `seedance20`
**Provider:** BytePlus ModelArk (ByteDance Seed) · **Underlying model:** Seedance 2.0 (flagship) · **Modality:** Text-to-video & image-to-video (first + last frame, reference images) · **Audio:** Yes (native audio-video joint generation, multilingual lip-sync)

The flagship of the Seedance 2.0 family: best prompt adherence, native multi-shot storytelling, native audio, and the only rtst Seedance model that renders up to 4K (2160p). Use it when quality and fidelity matter more than cost or speed; drop to `seedance20fast`/`seedance20mini` for cheaper 720p work, or `seedance15pro` for the older generation.

## rtst usage
```bash
rtst video create seedance20 --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `21:9`, `16:9`, `4:3`, `1:1`, `3:4`, `9:16`
- **Resolutions:** `480p`, `720p`, `1080p`, `2160p` (4K)
- **Durations (s):** `4`–`15` (any integer in range)
- **Audio:** Yes — enable with `--audio`
- **Image input:** `--first-frame <file>`, `--last-frame <file>` (frame interpolation), `--reference-image <file>` (repeatable, for subject/style guidance). Local files auto-upload; URLs also accepted.

## How to prompt it
Seedance 2.0 rewards structured, descriptive prompts. Use the BytePlus 6-step formula and aim for roughly 60–100 words:

**Subject → Action → Environment → Camera → Style → Constraints**

- **Subject:** who/what, with concrete attributes (age, material, wardrobe, type).
- **Action:** one clear present-tense verb describing the main motion.
- **Environment:** location, time of day, weather, set dressing.
- **Camera:** exactly ONE primary move. Seedance recognizes 8 movement types — Push-in (`dolly in`, `move toward`), Pull-out (`dolly out`, `reveal wide`), Pan (`lateral sweep`), Tracking (`follow shot`), Orbit (`arc around`, `rotate around`), Aerial (`drone shot`, `bird's-eye`), Handheld (`natural shake`, `documentary`), Fixed (`locked-off`, `camera holds still`).
- **Style:** lighting first (biggest quality lever — e.g. `golden-hour backlight`, `soft key light`), then lens (`wide` / `normal` / `telephoto`), film/color reference, and mood.
- **Constraints:** what to avoid.

Seedance 2.0's diffusion-transformer architecture tracks subjects across frames, so characters and environments stay consistent — this is what makes **native multi-shot** viable. Describe successive shots in the same prompt (e.g. "Wide establishing shot… then cut to a close-up…") and it holds identity and lighting across the cut. For **audio**, pass `--audio` and describe the desired sound in the prompt (ambient tone, dialogue intent, music mood); it can lip-sync speech in 8+ languages.

**Core rules:** keep camera movement separate from subject movement (mixing them is the top cause of shaky, uncontrolled output); use pacing words (`slow`, `smooth`, `gentle`) instead of technical speed parameters; prefer concrete description over vague adjectives ("beautiful", "amazing").

## Example prompts
```bash
rtst video create seedance20 --prompt "A weathered fisherman in a yellow raincoat hauls a net over the side of a wooden boat at dawn, rain streaking past. Slow dolly in toward his face as he strains. Cold blue overcast light, telephoto lens, muted cinematic color, gentle handheld feel." --aspect-ratio 16:9 --duration 8 --resolution 2160p --wait --json
```

```bash
rtst video create seedance20 --prompt "Neon-lit Tokyo alley at night, steam rising from vents, a lone cyclist glides past glowing signage. Camera tracks alongside the cyclist at a steady pace. Wet reflective pavement, saturated cyberpunk color grade, wide lens, moody synthwave ambience." --aspect-ratio 21:9 --duration 10 --resolution 1080p --audio --wait --json
```

```bash
rtst video create seedance20 --prompt "Animate this portrait: the woman slowly turns her head toward the camera and smiles as morning light warms her face. Camera holds a locked-off medium close-up. Soft natural key light, shallow depth of field, warm natural color." --first-frame ./portrait.jpg --aspect-ratio 9:16 --duration 6 --resolution 1080p --wait --json
```

## Limitations & tips
- **4K is exclusive to this model** in rtst — `seedance20fast` and `seedance20mini` cap at 720p. 4K/2160p renders are slower and more expensive; prototype at 720p, then re-run the winning prompt at 2160p.
- One primary camera move per prompt. Multiple conflicting moves cause jitter; use `--camerafixed`/"locked-off" wording for static framing.
- Long clips (12–15s) increase the chance of temporal flicker or identity drift — keep multi-shot sequences to 2–4 shots and re-state key subject attributes at each cut.
- BytePlus does not publicly document an exact multi-shot or audio/dialogue prompt *syntax*; express both through natural-language shot descriptions plus the `--audio` flag rather than special markup.
- Lighting descriptions have the single biggest impact on output quality — always include one.
