# Qwen-Image 2.0 Pro — `qwen-image-2.0-pro`

**Provider:** Alibaba (Qwen team) · **Underlying model:** Qwen-Image 2.0 Pro ·
**Modality:** text-to-image and image editing (unified model) ·

Qwen-Image 2.0 Pro is the highest-fidelity tier of Alibaba's unified
generation+editing model: an 8B Qwen3-VL encoder paired with a 7B diffusion
decoder, native **2048×2048** output, prompts up to ~1,000 tokens, and enhanced
text rendering, realistic textures, and semantic adherence. Reach for it for
final production assets — infographics, posters, presentation slides, comics,
bilingual CN/EN layouts — where quality beats speed. For surgical, character-level
in-place text edits on an existing image, `qwen-image` (Qwen-Image-Edit) is the
sharper tool; for photoreal ByteDance work use the `seedream*` family.

## rtst usage

```bash
rtst image create qwen-image-2.0-pro --prompt "..." [--image <file>] [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)

- **Input images:** `--image <file-or-url>` (repeatable; local files auto-upload)
  — omit for text-to-image, supply for editing.
- **`--samples N`** (1–10) — the 2.0 series can return multiple images per call
  (upstream cites 1–6); verify with `rtst model get qwen-image-2.0-pro --json`.
- `--grid 2x2|3x3` — render a single grid image instead of one picture (only valid with `--samples 1`; other pairings are ignored by the API).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
  fall between 512×512 and 2048×2048 with flexible width/height. Confirm the exact
  tokens rtst accepts with `rtst model get qwen-image-2.0-pro --json`.

## How to prompt it

- **Write detailed, well-ordered prompts.** It accepts long prompts (~1,000
  tokens), so specify subject, composition, materials/textures, lighting, and
  style — semantic adherence is a strength, so extra detail pays off.
- **Typography is a headline feature.** It renders accurately spelled, correctly
  positioned text — ideal for infographics, slides, and posters in English and
  Chinese. Quote the literal strings and state placement, e.g.
  `bold title "QUARTERLY REVIEW" centered at the top, subtitle below`.
- **Structured layouts:** describe panels, columns, charts, and label positions
  explicitly ("three-column layout", "legend in the lower-right").
- **Editing (with `--image`):** give a direct instruction (add / remove / replace
  / restyle / change viewpoint) and say which regions to keep unchanged; the
  unified model handles both generation and edits.
- **Realistic textures:** name materials (`brushed aluminum`, `frosted glass`,
  `linen`) and lighting to push photoreal detail.

## Example prompts

```bash
# 1. Text-heavy infographic (text-to-image)
rtst image create qwen-image-2.0-pro --prompt "Professional one-page infographic titled \"2026 GROWTH REPORT\", three-column layout with icons, two bar charts, correctly spelled English labels, clean corporate palette, crisp typography, 2048x2048" --width 2048 --height 2048 --wait --json

# 2. Bilingual poster
rtst image create qwen-image-2.0-pro --prompt "Film-festival poster, large title \"光影 / LIGHT & SHADOW\" in an elegant serif at the top, cinematic dusk cityscape below, credits block in small clean type at the bottom, high dynamic range" --samples 3 --wait --json

# 3. High-fidelity edit
rtst image create qwen-image-2.0-pro --prompt "Replace the plain background with a marble product-studio backdrop, add soft top lighting and a subtle reflection, keep the bottle and its label text unchanged" --image ./product.jpg --wait --json
```

## Limitations & tips

- **Cited (Qwen blog + host docs):** 8B VL encoder + 7B decoder, native 2K
  output, ~1,000-token prompts, strong CN/EN text rendering and semantic
  adherence, unified generation+editing, 1–6 images per call (upstream).
- **Vendor-marketing claims (treat as unverified):** "#1 on AI Arena blind
  human-eval leaderboard" and GEdit benchmark scores come from Qwen/press
  material, not independent replication.
- **Languages:** reliable text rendering is Simplified Chinese and English only.
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
  behavior for this endpoint is extrapolated from upstream Qwen docs — confirm
  with `rtst model get qwen-image-2.0-pro --json`.
- Built for quality over speed; expect slower generation than lite/turbo models.
  For pinpoint text *edits* on an existing image, `qwen-image` preserves the
  original font more precisely.
