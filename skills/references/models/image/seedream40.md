# Seedream 4.0 — `seedream40`

**Provider:** ByteDance (Seed) · **Underlying model:** Seedream 4.0 ·
**Modality:** text-to-image and image editing (unified architecture) ·

Seedream 4.0 folds generation and editing into one model: strong photoreal
output, best-in-class typography, native high-resolution (up to ~4K), and
multi-reference composition. Reach for it as an all-round quality default for
posters, product shots, and text-heavy layouts. For refined color/text and
better prompt adherence use `seedream45`; for the newest reasoning-driven
variant use `seedream50-lite`. Compared with the Qwen models (`qwen-image`,
`qwen-image-2.0-pro`) it is stronger on photoreal English/Chinese scenes;
Qwen leads on character-level in-place text edits.

## rtst usage

```bash
rtst image create seedream40 --prompt "..." [--image <file>] [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)

- **Input images:** `--image <file-or-url>` (repeatable; local files auto-upload).
  Multiple references let you assign roles (character / background / style).
- **`--samples N`** (1–10) — generate several variations per call.
- `--grid 2x2|3x3` — render a single grid image instead of one picture (only valid with `--samples 1`; other pairings are ignored by the API).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
  common square/portrait/landscape ratios (verify exact allowed values with
  `rtst model get seedream40 --json`).

## How to prompt it

**Text-to-image:** describe subject → attributes → setting → lighting → style,
front-loading the most important concept. Add photographic terms (`85mm lens`,
`shallow depth of field`, `golden hour`, `studio softbox`) and explicit style
tags (`cinematic`, `hyper-detailed`, `4K masterpiece`, `watercolor`).

**Editing (with `--image`):** use the **Action + Object + Attributes** formula.
- *Action:* `remove`, `replace`, `add`, `change`, `transform`.
- *Object:* `background`, `the jacket`, `the text`, `the lighting`.
- *Attributes:* `in a cyberpunk style`, `keep the font unchanged`, `warm tones`.

**Typography:** put the literal string in double quotes and state that style
should be preserved, e.g. `Change "OPEN" to "CLOSED" while keeping the exact
font, color, and position`. Seedream renders short English and Chinese headlines
and labels accurately — one of its standout strengths.

**Multi-reference:** name each image's role explicitly, e.g. `Use Image 1 for
the character, Image 2 for the background, apply the style of Image 3`. Good for
character redesigns, product variations, and consistent series.

**Avoid:** vague asks (`make it better`), and overloading one prompt with many
unrelated edits — break complex changes into sequential passes.

## Example prompts

```bash
# 1. Text-to-image poster with rendered headline
rtst image create seedream40 --prompt "Minimalist coffee-shop poster, steaming ceramic cup on a walnut table, warm morning light, bold headline text \"FRESH ROAST\" at the top in a clean sans-serif, muted earthy palette, 4K, commercial photography" --samples 4 --wait --json

# 2. Multi-reference composite
rtst image create seedream40 --prompt "Use Image 1 for the character and Image 2 for the neon-alley background; cinematic rim lighting, filmic color grade, keep the character's face and outfit consistent" --image ./hero.png --image ./alley.jpg --wait --json

# 3. Instruction edit with preserved typography
rtst image create seedream40 --prompt "Replace the background with a snowy mountain range at dusk, keep the subject and the text \"SUMMIT\" exactly as-is" --image ./ad.png --wait --json
```

## Limitations & tips

- **Cited (BytePlus/community guides):** unified generation+editing, up to ~4K
  output, accurate short-form English/Chinese text, up to ~10 reference images
  in the editing variant, Action+Object+Attribute editing formula.
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
  rtst — confirm with `rtst model get seedream40 --json` before a
  quality-critical job.
- Long paragraphs of body text and tiny fonts still degrade; keep rendered text
  to headlines and short labels.
- Very long, contradictory prompts reduce fidelity — front-load priorities and
  iterate with `--samples` rather than cramming everything into one string.
- Content-policy rejections surface as a failed job; read the printed body and
  adjust the prompt.
