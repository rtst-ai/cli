# Nano Banana 2 — `nanobanana2`

**Provider:** Google · **Underlying model:** Nano Banana 2 (reported as Gemini 3.1 Flash Image) ·
**Modality:** image editing / text-to-image

The next-gen Flash model: it takes the reasoning, world knowledge, and fidelity of Nano Banana Pro and delivers them at Flash speed — images in seconds instead of Pro's slower "thinking" pass. Reach for it as the default all-rounder: strong instruction following, subject consistency, and legible text without paying Pro's latency. Use `nanobananapro` when you need the absolute highest quality or the largest studio compositions; use base `nanobanana` for the cheapest quick edits.

## rtst usage

```bash
rtst image create nanobanana2 --prompt "..." [--image <file>] [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)

- **Input images:** `--image <file-or-url>` (repeatable, auto-uploaded) for editing / reference / multi-image fusion.
- `--samples N` (1–10), optional `--grid 2x2|3x3` (samples 1 only), `--width`/`--height`.
- Re-check the live, authoritative parameter set with `rtst model get nanobanana2 --json`.

## How to prompt it

Same editing-first, conversational style as the Nano Banana family — but NB2 follows **complex, multi-layered prompts more strictly**, so you can pack in more direction and expect it to be honored.

- **Lead with the operation** and describe the edit in plain language, referencing "this image" / specific subjects. State what changes and what to preserve.
- **Layered instructions are fine.** NB2 handles multi-step requests better than base — e.g. *"swap the background, relight to match, and add a subtle rim light on the subject; keep the face and clothing unchanged."*
- **Subject consistency:** maintains resemblance across a workflow (reported up to ~5 characters and high fidelity for up to ~14 objects). Pass reference images and restate identities for storyboards/narratives.
- **Multi-image fusion:** give multiple `--image` inputs and describe how they combine (subject vs. outfit vs. background). Reference them by role.
- **Text & localization:** crisp, accurate in-image text; put exact copy in quotes and name the font. It can also translate/localize text within an image — specify the target language.
- **Image-search grounding (world knowledge):** NB2 can ground on real-world references, so naming a real place, product, or landmark tends to produce more accurate depictions than a purely invented description.
- **Camera/lighting/lens language** works as in the rest of the family (low angle, f/1.8, golden hour, film stock, etc.).

**Text-to-image structure:** `[Subject] + [Action] + [Location/context] + [Composition] + [Style]`.

## Example prompts

```bash
# 1. Multi-step edit in a single prompt (NB2 follows layered instructions strictly)
rtst image create nanobanana2 --prompt "In this portrait, replace the background with a rainy neon-lit Tokyo street, relight the subject with cool blue key light and a warm rim light from behind, and keep the face, hairstyle, and jacket exactly the same." --image ./portrait.jpg --wait --json

# 2. Storyboard frame with subject consistency across references
rtst image create nanobanana2 --prompt "Using the same character from image 1 and the same dog from image 2, show them hiking up a misty mountain trail at dawn, wide cinematic shot. Keep both characters' appearance identical to the references." --image ./hero.png --image ./dog.png --wait --json

# 3. Text-heavy marketing mockup with localization
rtst image create nanobanana2 --prompt "A clean product landing hero: a matte-black wireless earbud case on a soft gradient. Render the headline \"PURE SOUND\" in a bold geometric sans-serif, and a smaller subhead \"All-day battery\" beneath it. Also provide a Japanese-localized version of the text." --samples 2 --wait --json
```

## Limitations & tips

- **Newer model, thinner public docs.** NB2's identity (Gemini 3.1 Flash Image), exact resolution tiers (reported 512px / 1K / 2K / 4K), and exotic aspect ratios (e.g. 4:1, 1:4, 8:1, 1:8) come from recent secondary/announcement sources and may shift — treat specifics as provisional and verify with `rtst model get nanobanana2 --json`.
- A separate **Nano Banana 2 Lite** variant exists (fastest/cheapest tier); this doc targets NB2 proper as wrapped by rtst.
- Which resolutions/aspect ratios rtst actually exposes is enforced by the API, not the raw model — `rtst model get` is ground truth.
- Still restate preservation requirements across iterations to avoid drift, though NB2 drifts less than base.
