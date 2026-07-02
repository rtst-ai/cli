# FLUX.2 — `flux-2` / `flux-2-image`

**Provider:** Black Forest Labs (BFL) · **Underlying model:** FLUX.2 ·
**Modality:** text-to-image (`flux-2`) and image editing / multi-reference (`flux-2-image`) ·

FLUX.2 is BFL's frontier image model, known for strong prompt adherence, sharp
photorealism, and the most legible in-image text/typography of any current model.
Use `flux-2` for pure text-to-image; use `flux-2-image` when you want to edit,
transform, or combine one or more reference images (character/product/style
consistency across generations).

## rtst usage

```bash
# Text-to-image
rtst image create <name> --prompt "..." [--samples N] [--grid 2x2] [--width <px> --height <px>] --wait --json

# Image editing / multi-reference (repeatable --image, auto-uploaded)
rtst image create <name> --prompt "..." --image ref1.png --image ref2.png [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)

- **Prompt:** `--prompt "..."` (required). Natural language; no negative-prompt syntax (see below).
- **Input images:** `--image <file-or-url>` — only for the `flux-2-image` variant.
  Repeatable; local files are auto-uploaded. Up to ~10 references are supported by
  FLUX.2 for combining/consistency (BFL cites up to 10; some providers list 8 — see Limitations).
- **`--samples N`** (1–10) — number of images to generate.
- `--grid 2x2|3x3` — render a single grid image instead of one picture (only valid with `--samples 1`; other pairings are ignored by the API).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
- **`--wait`** — block until generation completes.
- **`--json`** — machine-readable output.

Do not pass flags beyond the set above — this is the full rtst surface for these models.

## How to prompt it

Guidance below is from BFL's official FLUX.2 prompting guide (docs.bfl.ml) unless noted.

- **Framework: Subject + Action + Style + Context.** Word order matters — put the
  most important elements first (main subject → key action → critical style →
  essential context → secondary details).
- **Prompt length:** short 10–30 words for quick concepts; **medium 30–80 words is
  ideal for most work**; 80+ words for complex, multi-element scenes.
- **No negative prompts.** FLUX.2 does not support them. Describe what you *want*
  (e.g. "sharp focus," "clean background"), not what to exclude.
- **Text / typography:** enclose the literal string in quotes — `The sign reads
  "OPEN" in red neon`. Specify placement, style ("elegant serif," "bold industrial
  lettering"), and size ("large headline," "small body copy"). FLUX.2 renders long
  strings, punctuation, and case reliably.
- **Color precision:** signal a hex code with a keyword and bind it to an object —
  `a ceramic vase in color #0047AB`. Vague references ("use #FF0000 somewhere") are
  inconsistent. Gradients: give start and end hex values.
- **Photorealism:** name camera/lens, film stock, and lighting — e.g. "shot on
  Hasselblad X2D, 80mm f/2.8, natural window light," or "Kodak Portra 400, natural
  grain." Specific gear beats generic phrases like "professional photo."
- **JSON structured prompts** are supported for complex/production scenes (fields
  like `scene`, `subjects`, `style`, `color_palette`, `lighting`, `camera`).
- **`flux-2-image` (editing):** keep the text prompt simple and let the reference
  images carry the visual detail. Use references for anything hard to describe in
  words — a specific face, product, or style you want held constant across variants.

## Example prompts

```bash
# 1. Text-to-image: typography-heavy poster
rtst image create flux-2 --prompt "A minimalist product poster, centered bold sans-serif headline reading \"FLUX 2\" in color #111827 on a warm off-white background, small subheading \"Frontier Visual Intelligence\" below, soft studio lighting, high detail, clean composition" --samples 4 --wait --json

# 2. Text-to-image: photorealistic product shot
rtst image create sneaker-hero --prompt "A white leather sneaker on a matte concrete surface, dramatic side lighting with soft shadow, shot on Hasselblad X2D, 80mm f/2.8, shallow depth of field, crisp fabric and stitching texture" --param image_size=2K --wait --json

# 3. Image editing / multi-reference: place a product in a new scene
rtst image create bottle-in-kitchen --prompt "Place this bottle on a sunlit marble kitchen counter beside fresh herbs, morning light, photorealistic, keep the label sharp and legible" --image ./bottle.png --image ./kitchen-style.jpg --samples 2 --wait --json
```

## Limitations & tips

- **New model, thin/conflicting sourcing.** FLUX.2 is recent; some numbers vary by
  provider. BFL states up to **10** reference images, but the [pro] API notes a
  ~9MP combined input+output budget (e.g. ~8 references at 1MP output, fewer at
  higher output resolution), and some third-party pages cite 8. Treat the exact
  reference cap and max resolution as provider-dependent; test against the rtst API.
- **rtst flag mapping is inferred.** The prompting/capability guidance is cited from
  BFL docs, but how rtst maps `--width`/`--height` values and the exact `--image` cap to
  FLUX.2 is not documented in the sources here — verify empirically.
- **No negative prompts** — a hard model limitation, not a CLI gap.
- **Text accuracy is strong but not perfect** — complex typography lands roughly on
  the first try more often than older models but may still need reruns; use `--samples`
  to get variants and pick the cleanest.
- **Bind colors and text to objects.** Floating hex codes or unquoted text degrade
  results; quote strings and attach hex to a named element.
- For consistency work (same character/product across many images), prefer
  `flux-2-image` with a reference over trying to describe the subject in words.

<!--
Sources:
- BFL official FLUX.2 prompting guide: https://docs.bfl.ml/guides/prompting_guide_flux2
- BFL FLUX.2 launch / model pages: https://bfl.ai/blog/flux-2 , https://bfl.ai/models/flux-2
- Secondary: replicate.com/black-forest-labs/flux-2-pro , together.ai FLUX.2 multi-reference blog
-->
