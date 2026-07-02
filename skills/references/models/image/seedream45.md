# Seedream 4.5 — `seedream45`

**Provider:** ByteDance (Seed) · **Underlying model:** Seedream 4.5 ·
**Modality:** text-to-image and image editing (unified architecture) ·

Seedream 4.5 is an incremental upgrade over `seedream40`: a dramatically
improved text-rendering system (multi-line layouts, more font styles, special
characters), better color accuracy / dynamic range, fewer artifacts, and
tighter prompt adherence and style control. Reach for it when typography and
color fidelity matter — posters, infographics, branded layouts. For the newest
reasoning-driven ByteDance model use `seedream50-lite`; for the baseline use
`seedream40`. Versus Qwen (`qwen-image`, `qwen-image-2.0-pro`) it favors
photoreal scene generation; Qwen still leads on character-level in-place text edits.

## rtst usage

```bash
rtst image create seedream45 --prompt "..." [--image <file>] [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)

- **Input images:** `--image <file-or-url>` (repeatable; local files auto-upload).
  Blend multiple references into a new composition, or edit a single image.
- **`--samples N`** (1–10) — variations per call.
- `--grid 2x2|3x3` — render a single grid image instead of one picture (only valid with `--samples 1`; other pairings are ignored by the API).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
  sizes include square `1024²/1536²/2048²`, portrait `1024×1536`, `1024×2048`,
  landscape `1536×1024`, `2048×1024`. Confirm the exact tokens rtst accepts with
  `rtst model get seedream45 --json`.

## How to prompt it

Use the five-part structure the 4.5 guide recommends, **front-loading the most
important concept** (4.5 weights earlier tokens more heavily):

> **subject → style → composition → lighting/atmosphere → technical params.**

- **Length:** aim for ~30–100 words. 4.5 can get confused by overly long prompts.
- **Lighting** is a strong lever: `golden hour`, `dramatic side lighting`,
  `soft diffused light`, `low-key`, `high-key`.
- **Technical tags:** `85mm lens`, `shallow depth of field`, `4K detail`.
- **Text:** quote the literal string, specify font characteristics, and keep it
  concise — 4.5 handles serif/sans-serif/script/display fonts and multi-line
  layouts with correct spelling.
- **Editing (with `--image`):** same Action + Object + Attributes pattern as 4.0
  (`replace the background…`, `change "OPEN" to "CLOSED", keep the font`).
- **Troubleshooting:** for wrong style use explicit negations (`not cartoon-like`)
  and reinforce the target aesthetic; for messy composition, state spatial
  relationships and use photography terms (`medium shot`).

## Example prompts

```bash
# 1. Typography-heavy infographic (text-to-image)
rtst image create seedream45 --prompt "Clean fitness infographic, three vertical panels, bold multi-line headline \"TRAIN SMART\" with sans-serif subtitles, flat pastel palette, soft even lighting, crisp vector look, high resolution" --width 2048 --height 2048 --samples 3 --wait --json

# 2. Photoreal portrait, front-loaded subject
rtst image create seedream45 --prompt "Female CEO with short blonde hair, confident expression, navy suit; corporate headshot style, neutral office background, studio lighting, shallow depth of field, 85mm, high-end" --wait --json

# 3. Instruction edit preserving text and color
rtst image create seedream45 --prompt "Change the sky to a dramatic sunset with warm side lighting, keep the storefront and the sign text \"BAKERY\" unchanged" --image ./shop.jpg --wait --json
```

## Limitations & tips

- **Cited (wavespeed/fal 4.5 guides):** improved text rendering, better color/
  dynamic range, tighter prompt adherence; max 2048×2048; the specific size list
  above; earlier-token weighting; ~30–100 word sweet spot.
- **Inferred / unverified:** BytePlus's official "4.0–4.5" doc page did not
  return prompt-guide content at fetch time, so **reference-image count and the
  exact rtst `--width`/`--height` limits and aspect handling for 4.5 are extrapolated from 4.0 plus
  community guides, not confirmed primary docs.** Verify with
  `rtst model get seedream45 --json` before relying on any specific value.
- As with 4.0, dense body text and very small fonts still degrade; keep rendered
  copy to headlines and short labels.
