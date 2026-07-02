# Seedream 5.0 Lite — `seedream50-lite`

**Provider:** ByteDance (Seed) · **Underlying model:** Seedream 5.0 Lite ·
**Modality:** text-to-image and image editing (unified multimodal) ·

Seedream 5.0 Lite is ByteDance's newest image model (released ~Feb 2026). Vendor
positioning describes it as a "reasoning-first" unified model with deep-thinking
and live web-search abilities, stronger complex-prompt following, native 2K/4K
output, and identity/face preservation through edits. Reach for it when a prompt
needs spatial reasoning or up-to-date references and you still want fast,
high-res output. For a mature, well-documented baseline use `seedream45` or
`seedream40`. Versus Qwen (`qwen-image`, `qwen-image-2.0-pro`), Seedream leans
photoreal/compositional; Qwen leads on character-level in-place text edits.

## rtst usage

```bash
rtst image create seedream50-lite --prompt "..." [--image <file>] [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)

- **Input images:** `--image <file-or-url>` (repeatable; local files auto-upload).
  Vendor docs cite compositing from **up to ~14 reference images** in one edit.
- **`--samples N`** (1–10) — variations per call.
- `--grid 2x2|3x3` — render a single grid image instead of one picture (only valid with `--samples 1`; other pairings are ignored by the API).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
  tokens rtst accepts with `rtst model get seedream50-lite --json`.

## How to prompt it

- **Be specific and structured**, but you can lean on its stronger prompt
  following: nuanced instructions about **camera angle, lighting setup, color
  palette, spatial relationships, and composition** are respected more literally
  than in 4.x rather than loosely interpreted.
- **Reasoning tasks:** it can infer from partial/scattered inputs (assemble parts
  into an object, continue a state), so you can describe the *intended outcome*
  and let the model reason about arrangement.
- **Editing (with `--image`):** same Action + Object + Attributes pattern as the
  rest of the Seedream family; it emphasizes **identity/face preservation**
  (eyes, jawline, proportions, skin tone) across style transforms — good for
  "same person, new style/outfit/scene" edits.
- **Typography:** quote the literal text and keep it concise; the Seedream line
  is strong on short English/Chinese headlines and labels.
- **Multi-reference:** assign explicit roles per image (character / background /
  style / product) for consistent composites.

## Example prompts

```bash
# 1. Reasoning-driven composition (text-to-image)
rtst image create seedream50-lite --prompt "An exploded-view diagram of a mechanical wristwatch reassembled into a finished watch on the right, clean studio lighting, top-down and 3/4 views side by side, labeled parts, crisp 4K product render" --param image_size=4K --samples 2 --wait --json

# 2. Identity-preserving restyle (edit)
rtst image create seedream50-lite --prompt "Keep this person's exact facial features and skin tone; restyle as a Renaissance oil-painting portrait with soft chiaroscuro lighting and a dark background" --image ./face.jpg --wait --json

# 3. Multi-reference composite
rtst image create seedream50-lite --prompt "Place the product from Image 1 in the minimalist studio from Image 2, match the lighting of Image 2, centered hero shot, 2K" --image ./bottle.png --image ./studio.jpg --param image_size=2K --wait --json
```

## Limitations & tips

- **Cited (ByteDance model page + vendor guides):** unified multimodal model,
  native 2K/4K, up to ~14 reference images, improved complex-prompt following,
  identity/face preservation, fast (~2–3s/image) generation.
- **Vendor-marketing claims (treat as unverified):** "deep thinking / visual
  reasoning" and "real-time web search at generation time" come from ByteDance
  promo and third-party blogs, not independent benchmarks — validate empirically.
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
  the real reference-image cap for this endpoint are **inferred**; check
  `rtst model get seedream50-lite --json` before a quality-critical run.
- "Lite" implies a speed/cost-tuned tier; expect occasional quality trade-offs
  vs a full 5.0 model. Use `--samples` to select the best of several.
