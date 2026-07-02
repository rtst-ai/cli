# Qwen Image Edit — `qwen-image`

**Provider:** Alibaba (Qwen team) · **Underlying model:** Qwen-Image-Edit (20B) ·
**Modality:** instruction-based image editing (requires an input image) ·

Qwen-Image-Edit extends Qwen-Image's text-rendering strength to editing. It
feeds the input through both a vision-language encoder (Qwen2.5-VL, for
*semantic* control) and a VAE (for *appearance* control), so it can do both
low-level pixel edits and high-level semantic edits — while excelling at
**precise, character-level text editing in Chinese and English** with the
original font/size/style preserved. Reach for it whenever the edit involves
text or surgical in-place changes. For higher-fidelity generation *and* editing
in one model use `qwen-image-2.0-pro`; for photoreal ByteDance edits use the
`seedream*` family.

## rtst usage

```bash
rtst image create qwen-image --prompt "..." --image <file> [--samples N] --wait --json
```

This is an **edit** model — always pass at least one `--image`.

## Parameters (enforced by the rtst API)

- **Input images:** `--image <file-or-url>` (repeatable; local files auto-upload).
  Upstream Qwen-Image-Edit supports **1–3 images**, referenced by ordinal
  position (`Image 1`, `Image 2`, `Image 3`).
- **`--samples N`** (1–10) — note the base `qwen-image-edit` upstream returns a
  single image per call; rtst may fan out samples. Verify with
  `rtst model get qwen-image --json`.
- `--grid 2x2|3x3` — render a single grid image instead of one picture (only valid with `--samples 1`; other pairings are ignored by the API).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
  variants often 512–2048). Confirm the exact tokens rtst accepts with
  `rtst model get qwen-image --json`.

## How to prompt it

- **Give a direct instruction**, not a scene description. Name the action and the
  target: add / remove / move an object, change a pose, replace the background,
  transfer a style, change the viewpoint, enhance detail.
- **Text edits are the headline feature.** Quote both strings and ask to preserve
  style, e.g.:
  - `Replace "HEALTH INSURANCE" on the tiles with "Tomorrow Will Be Better"`
  - `Change "Qwen-Image" to a black ink-drip font`
  - `Change "Qwen-Image" to red` · `Change the material of "Qwen-Image" to metal`
  It edits at the **character level** and keeps the surrounding typeface, weight,
  and size — insert, delete, or modify specific words in CN/EN.
- **Region targeting:** use spatial descriptors (`upper-left corner`,
  `the left shoulder`, `the area marked by the red circle`) or ordinal image refs.
- **Multi-image composition:** `The girl in Image 1 wears the black dress from
  Image 2 and sits in the pose from Image 3`.
- **Semantic vs appearance:** for appearance edits, explicitly say to keep all
  other regions unchanged; for semantic edits (IP/style/rotation), allow overall
  pixel change while keeping identity/semantics consistent.

## Example prompts

```bash
# 1. Precise text swap, preserve font
rtst image create qwen-image --prompt "Change the sign text \"OPEN\" to \"SORRY, CLOSED\" using the same font, color, and size; leave everything else unchanged" --image ./storefront.jpg --wait --json

# 2. Bilingual text edit
rtst image create qwen-image --prompt "Replace the English word \"Hello\" on the mug with the Chinese \"你好\" in a matching font style" --image ./mug.png --wait --json

# 3. Multi-image compose
rtst image create qwen-image --prompt "The person in Image 1 wears the jacket from Image 2, keep their face and pose; studio background" --image ./person.jpg --image ./jacket.png --wait --json
```

## Limitations & tips

- **Cited (Alibaba Model Studio + Qwen docs):** dual semantic+appearance editing,
  character-level CN/EN text editing with font preservation, 1–3 input images,
  384–3072 px range, single-image output for base `qwen-image-edit`, 24-hour
  validity on generated URLs (upstream API detail).
- **Languages:** only Simplified Chinese and English text render reliably.
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
  confirm with `rtst model get qwen-image --json`.
- It's an editor, not a from-scratch generator: results depend on a good input
  image. For pure text-to-image at high fidelity, prefer `qwen-image-2.0-pro`
  or a `seedream*` model.
- Keep each instruction focused; chain multiple distinct edits across separate
  calls rather than one overloaded prompt.
