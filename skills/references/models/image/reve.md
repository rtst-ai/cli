# Reve Image Edit — `reve`
**Provider:** Reve AI (reve.art / reve.com) · **Underlying model:** Reve Image edit (codename "Halfmoon"; 2.0-generation editing model) · **Modality:** image editing (also text-to-image) ·
Reve is a natural-language image editor noted for exceptional prompt adherence and industry-leading text/typography rendering. In rtst it is used as an editing model: pass one or more input images with `--image` plus a plain-English `--prompt` describing the change.

## rtst usage
```bash
rtst image create reve --prompt "..." [--image <file>] [--samples N] --wait --json
```
`--image` is auto-uploaded; it is repeatable, so you can supply several reference images and Reve will combine them into a single output (e.g. place a product from one image into a scene from another). With no `--image`, `reve` behaves as a text-to-image generator.

## Parameters (enforced by the rtst API)
- Input images: `--image <file-or-url>` — repeatable, auto-uploaded. One image = edit that image; multiple = multi-reference composition.
- `--prompt` — natural-language edit instruction (the primary control surface).
- `--samples N` (1-10) — number of variations. Reve's edit model natively returns diverse variants per request, so >1 sample is useful for picking the best result.
- `--grid 2x2|3x3` — render a single grid image instead of one picture (only valid with `--samples 1`; other pairings are ignored by the API).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
- `--wait` / `--json` — block until done and emit machine-readable output.

## How to prompt it
Reve's headline strengths are **prompt adherence** and **typography**, so plain, specific, declarative instructions work well — you generally do NOT need heavy "prompt-engineering" or long modifier stacks (CITED: Reve markets results from minimal prompts like "shift focus to the man" or "render as if shot at f/1.8").

Editing best practices (general image-edit guidance, applied to Reve — see Sources):
- **Name subjects directly.** Say "the woman with short black hair" or "the red car," not "her" / "it."
- **State the change, then what to preserve.** e.g. "Change the sky to sunset while keeping the exact camera angle, framing, and the subject unchanged." Reve is good at localized edits (remove shadows, swap backgrounds, restore/retouch) without disturbing the rest.
- **One clear intent per prompt** (or a few comma-separated edits). Layer instructions sparingly; avoid stuffing many unrelated changes into one prompt.
- **Lean on text/typography.** Reve renders embedded text, logos, signage and posters unusually accurately — spell the exact words in quotes and describe placement/style (e.g. `add a neon sign reading "OPEN" in the top-right window`).
- **For multi-image composition**, describe the role of each input: "Place the sneaker from the first image onto the model in the second image, matching the lighting."
- **Photographic control** works via natural language: focal length / f-stop, focus subject, lighting mood, time of day.

## Example prompts
```bash
# Single-image natural-language edit, preserving composition
rtst image create reve --image street.jpg \
  --prompt "Change the season to winter with fresh snow on the ground and rooftops, keep the exact camera angle and the pedestrians unchanged" \
  --wait --json
```
```bash
# Typography-heavy edit (Reve's strong suit), pick from 4 variants
rtst image create reve --image cafe.jpg --samples 4 \
  --prompt 'Add a hanging wooden sign above the door that reads "The Corner Cafe" in warm hand-painted serif lettering' \
  --wait --json
```
```bash
# Multi-image composition
rtst image create reve --image product.png --image scene.jpg \
  --prompt "Place the perfume bottle from the first image onto the marble table in the second image, match the soft window lighting and add a subtle reflection" \
  --wait --json
```

## Limitations & tips
- **Sources are thin / new.** Reve is a niche, recently launched model; official docs give strong marketing claims but little concrete per-parameter prompting guidance. Vendor accuracy figures (e.g. "98% text accuracy," 4K upscaling) are CITED from Reve/aggregator pages and are not independently verified here.
- **Edit-specific prompt syntax is INFERRED.** The naming/preserve-composition tips above come from general AI-image-edit best practices, not a Reve-published prompt guide; treat them as strong defaults, not documented rules.
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
- **Diversity over benchmark-chasing.** Reve deliberately favors diverse outputs, so generate multiple `--samples` and pick, rather than expecting one deterministic result.
- **Best for:** natural-language edits, background/season/lighting swaps, object add/remove/move, image restoration, and any task involving legible text, logos, or signage. Less suited to pixel-exact masked compositing — Reve is instruction-driven, not a layer/mask tool.

### Sources
- Reve editing model announcement — https://blog.reve.com/posts/reve-editing-model/
- The new Reve (products & layout editing) — https://blog.reve.com/posts/the-new-reve/
- Reve Image 1.0 launch / capabilities — https://venturebeat.com/ai/the-new-best-ai-image-generation-model-is-here-say-hello-to-reve-image-1-0
- Reve Edit Image model (inputs, resolution, multi-variant) — https://aimlapi.com/models/reve-edit-image
- General AI image-editing prompt best practices — https://askyourpdf.com/blog/ai-photo-editing-prompts
