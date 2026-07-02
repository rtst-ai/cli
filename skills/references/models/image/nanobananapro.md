# Nano Banana Pro — `nanobananapro`

**Provider:** Google · **Underlying model:** Nano Banana Pro (Gemini 3 Pro Image) ·
**Modality:** image editing / text-to-image

The top-tier, studio-grade member of the family: highest quality, best-in-class in-image text, up to 4K output, and large multi-reference compositions. It runs a slower reasoning ("thinking") pass, so it trades speed for fidelity. Reach for it for posters, packaging, infographics, brand assets, and complex scenes; use `nanobanana2` when you want most of this quality at Flash speed, or base `nanobanana` for quick throwaway edits.

## rtst usage

```bash
rtst image create nanobananapro --prompt "..." [--image <file>] [--samples N] --param image_size=4K --wait --json
```

## Parameters (enforced by the rtst API)

- **Input images:** `--image <file-or-url>` (repeatable, auto-uploaded) for editing / reference / multi-image composition.
- `--samples N` (1–10), optional `--grid 2x2|3x3` (samples 1 only), `--width`/`--height`.
- Re-check the live, authoritative parameter set (including whether `4k`/`2k` are selectable) with `rtst model get nanobananapro --json`.

## How to prompt it

Pro rewards **detailed, sophisticated direction** — it uses Gemini 3's reasoning and world knowledge, so more specific prompts translate into more control rather than confusion.

- **Describe the full creative brief:** subject, setting, composition, lighting direction, color grade, lens/camera, mood, and intended use (poster, ad, packaging). Vague prompts underuse the model.
- **Text rendering is its headline strength.** It renders short taglines through long paragraphs legibly, across many fonts, textures, and calligraphy, in multiple languages. Put exact copy in quotes, specify per-line font/weight/style, and it will place it cleanly. Great for mockups, diagrams, and posters.
- **Multilingual + localization:** ask it to translate or localize the in-image text into target languages.
- **Big multi-reference compositions:** supports up to ~14 input images — use them as a full "style guide" (logos, color palette, character turnarounds, product shots) in one prompt. Reference each by role.
- **Character consistency:** keeps up to ~5 people consistent across a complex scene. Restate identities and provide clean reference shots.
- **Studio creative controls via prompt:** localized/region edits, camera-angle and focus changes, depth-of-field/bokeh, day-to-night relighting, color grading, and aspect-ratio changes.
- **Editing discipline still applies:** say what changes and what to preserve; iterate in small steps for surgical edits.

**Text-to-image structure:** `[Subject] + [Action] + [Location/context] + [Composition] + [Style]`, plus explicit text and typography blocks.

## Example prompts

```bash
# 1. Text-rich poster at high resolution
rtst image create nanobananapro --prompt "A vintage travel poster for Kyoto in autumn: a temple among red maples, warm risograph texture, muted teal and orange palette. Render the title \"KYOTO\" in a tall elegant serif at the top and \"Autumn 2026\" in a thin sans-serif at the bottom. Balanced composition with negative space." --param image_size=4K --wait --json

# 2. Full style-guide composition from many references
rtst image create nanobananapro --prompt "Build a product hero using image 1 (logo), image 2 (brand color palette), image 3 (the bottle), and image 4 (model). Place the bottle in the model's hand on a studio backdrop matching the palette, add the logo top-left, soft three-point lighting, crisp reflections." --image ./logo.png --image ./palette.png --image ./bottle.png --image ./model.jpg --wait --json

# 3. Studio relight + color grade edit
rtst image create nanobananapro --prompt "Take this daytime street photo and convert it to a moody night scene: relight with warm shop signage and cool ambient light, add subtle wet-pavement reflections and shallow depth of field. Keep the buildings, people, and composition identical." --image ./street.jpg --param image_size=2K --wait --json
```

## Limitations & tips

- **Slower than Flash siblings.** The reasoning pass adds latency; if you don't need 4K or heavy text, `nanobanana2` is faster for similar quality.
- **Recent model, evolving docs.** Capabilities cited here (Gemini 3 Pro Image, up to 14 reference images, ~5-character consistency, 1K/2K/4K) come from Google's launch materials and recent secondary sources; treat exact numbers as provisional and verify with `rtst model get nanobananapro --json`.
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
- Higher resolution and multi-reference jobs cost more credits/time; scope references to what the composition actually needs.
