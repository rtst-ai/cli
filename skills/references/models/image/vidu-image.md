# Vidu Reference-to-Image — `vidu`

**Provider:** Shengshu Technology (ShengShu-AI / vidu.com) · **Underlying model:** Vidu reference-to-image (Q1/Q2 image family) · **Modality:** reference-to-image / image editing ·

Vidu's image model is a **subject-consistent, reference-driven** generator: you supply
one or more reference images (characters, faces, products, logos, scenes) and it
produces new images that keep those subjects consistent. Shengshu positions it as an
"image compositing" / "reinvent photography" tool competing with Nano Banana
(Gemini Flash Image) and FLUX Kontext, with a strong claim on multi-subject
consistency and preserved in-image text.

> Note: rtst also exposes a **`vidu` video model** (Vidu Q2 reference-to-video). This
> doc covers the **image** model only.

## rtst usage

```bash
rtst image create vidu --prompt "..." --image ref1.jpg [--image ref2.jpg ...] [--samples N] [--grid 2x2] [--width <px> --height <px>] --wait --json
```

## Parameters (enforced by the rtst API)

- **Prompt:** `--prompt "..."` — describes the target scene/edit and how the
  referenced subjects should appear together.
- **Input images:** `--image <file-or-url>` — **repeatable**; local files are
  auto-uploaded. Each image is a reference subject/element to keep consistent.
  Vidu supports **up to 7 reference images** at once (cited by Shengshu).
- **`--samples N`** (1–10) — number of images to generate.
- `--grid 2x2|3x3` — render a single grid image instead of one picture (only valid with `--samples 1`; other pairings are ignored by the API).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
- **`--wait`** — block until generation completes.
- **`--json`** — machine-readable output.

Do not pass flags beyond the set above — this is the full rtst surface for this model.

## How to prompt it

Guidance below is cited from Shengshu/Vidu announcements and reputable secondary
guides where noted; rtst-specific flag behavior is inferred and marked as such.

- **Let the references carry identity; let the prompt carry the scene.** Use clean,
  well-lit reference images with clear subject separation (simple backgrounds help
  Vidu isolate the subject). The text prompt should focus on the new composition —
  action, setting, lighting, mood, and how subjects relate. (Cited: Vidu guides.)
- **Multi-subject composition.** With several references you can *synthesize*
  (place different people/objects into one scene), *replace* (swap a background,
  outfit, or object), or *transform/add* (insert new elements, adjust lighting,
  repair details). Name each referenced subject in the prompt so Vidu knows how to
  place it. (Cited: Shengshu Q1 launch — "synthesis, replacement, transformation.")
- **Labeling subjects (inferred for image use):** Vidu's reference *video* workflow
  uses `@`-style subject labels (e.g. `@a(woman in red coat), @b(man in denim)…`).
  Whether the image endpoint honors the same syntax is **not confirmed for the rtst
  image path** — a plain descriptive prompt referring to "the woman from the first
  image / the product in image 2" is the safe default.
- **Preserve text and logos.** Vidu claims strong fidelity on in-image text, faces,
  and layouts, so provide the logo/text as a reference rather than describing it.
- **Composition cues help stability.** Front-facing or slight three-quarter subject
  references and explicit framing ("centered composition, chest-up, eye level")
  improve consistency. (Cited: Vidu character-consistency guide.)
- **Reference quality dominates output quality.** High-resolution, clean references
  preserve identity far better than describing the subject in words.

## Example prompts

```bash
# 1. Multi-subject synthesis: put two referenced people into one new scene
rtst image create vidu --prompt "The woman from image 1 and the man from image 2 sit together at a sunlit cafe table, warm morning light, candid photojournalistic style, sharp faces" --image ./woman.jpg --image ./man.jpg --samples 4 --wait --json

# 2. Product placement / replacement: keep the product and its label consistent
rtst image create vidu --prompt "Place this bottle on a marble kitchen counter beside fresh herbs, soft window light, photorealistic, keep the label text crisp and legible" --image ./bottle.png --image ./kitchen.jpg --wait --json

# 3. Single-subject transform: restyle a portrait while holding identity
rtst image create vidu --prompt "Same person, now in a tailored navy suit, standing in a modern glass office, cinematic rim lighting, high detail" --image ./portrait.jpg --samples 2 --wait --json
```

## Limitations & tips

- **Sourcing is thin and version-fuzzy.** Vidu's image model ships under several
  names over time (Q1 → Q2 image, "reference-to-image", "image compositing"). The
  **7-image cap** and **1080p** figures are cited by Shengshu/press, but exact API
  limits (max references honored, resolution options, accepted formats — press cites
  JPG/PNG/WEBP up to ~10MB each) can vary by provider and were not confirmed against
  the rtst API. Verify empirically.
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
  precise `--image` cap onto Vidu is not documented in the sources here — test it.
- **Subject-label syntax unconfirmed for images.** The `@a(...)` labeling comes from
  Vidu's reference-to-**video** docs; don't rely on it for the image endpoint until
  confirmed. Descriptive references ("image 1 / image 2") are the safe path.
- **Consistency degrades with large casts.** Vidu holds up to ~7 subjects; more than
  that, or crowded ensemble scenes, get less reliable. (Cited: Vidu guides.)
- **Best-image workflow:** generate several with `--samples`  and pick
  the cleanest — reference-driven models still vary run to run.
- **Distinct from the `vidu` video model.** If you want animation/motion, that's the
  Vidu Q2 reference-to-video model, not this image endpoint.

<!--
Sources:
- Shengshu / Vidu launch & compositing announcements:
  https://www.prnewswire.com/news-releases/vidu-q1-model-update-unveils-multi-reference-feature-supporting-up-to-seven-image-inputs-302499846.html
  https://www.prnewswire.com/news-releases/from-camera-to-code-vidu-seeks-to-reinvent-photography-with-image-compositing-using-7-references-to-create-true-to-life-images-from-scratch-302549023.html
  https://siliconangle.com/2025/09/08/vidu-launches-ai-image-generation-update-reference-image-creating-imaginative-realism/
  https://news.aibase.com/news/21151
- Prompting / consistency guides (secondary):
  https://vidu-ai.net/prompt-engineering/character-consistency
  https://imastudio.com/blog/vidu-q2-reference-guide
  https://www.vidu.com/ai-reference-to-video
-->
