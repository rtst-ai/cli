# Nano Banana — `nanobanana`
**Provider:** Google · **Underlying model:** "Nano Banana" (Gemini 2.5 Flash Image) · **Modality:** Image editing / text-to-image ·

Google's fast, conversational image model — the original "Nano Banana." It excels at **instruction-based editing**, character/subject consistency across edits, and multi-image fusion, all at low latency and cost. In rtst it's an img2img/editing model: pass `--prompt` plus one or more `--image` inputs. Use it as the everyday workhorse; step up to `nanobanana2` or `nanobananapro` when you need higher fidelity, 4K, or the best in-image text.

## rtst usage
```bash
rtst image create nanobanana --prompt "..." [--image <file>] [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)
- **Input images:** `--image <file-or-url>` — repeatable, local files auto-upload. One image → edit it; multiple → fuse/reference (e.g. put the subject from image 1 into the scene of image 2). Great at keeping a character consistent.
- **`--samples N`** (1–10) — number of variations; optional `--grid 2x2|3x3` (samples 1 only).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).

## How to prompt it
Prompt it like you're **giving directions to a photo editor**, not writing a caption.

- **Describe the change conversationally and reference the existing image**: "make the sky a dramatic sunset", "put this person in a business suit", "remove the passerby on the right". It's tuned to understand edits against the provided image.
- **Name what to keep.** "…while keeping her face and pose exactly the same" preserves identity through big changes.
- **Multi-image fusion:** state the roles — "combine the subject from image 1 with the background of image 2, matching the lighting."
- **Iterate in steps.** It responds well to sequential, one-change-at-a-time edits rather than a single overloaded prompt.
- **Text in image:** put the exact words in quotes (`add the text "OPEN"`). Base Nano Banana renders short strings acceptably; for dense/print-grade typography prefer `nanobananapro`.
- **Photographic control:** camera/lens/lighting terms ("85mm portrait, soft window light, shallow depth of field") steer style effectively.

## Example prompts
```bash
# 1. Simple instruction edit
rtst image create nanobanana --prompt "Replace the background with a sunlit tropical beach, keep the person's face, hair, and pose unchanged" --image ./portrait.jpg --wait --json
```

```bash
# 2. Multi-image fusion / product placement
rtst image create nanobanana --prompt "Place the sneaker from image 1 onto the model's feet in image 2, matching the studio lighting and perspective" --image ./sneaker.png --image ./model.jpg --wait --json
```

```bash
# 3. Text-to-image with photographic direction, several options
rtst image create nanobanana --prompt "A cozy corner coffee shop at golden hour, warm bokeh, 35mm, cinematic color grade, people softly out of focus" --samples 4 --wait --json
```

## Limitations & tips
- **Fidelity vs. siblings:** base Nano Banana is fast and cheap but lower-fidelity than `nanobanana2` / `nanobananapro`; for hero shots, fine text, or 4K, use those.
- **Text rendering** on the base model is decent for short labels but can garble long or stylized typography — prefer `nanobananapro` for posters/packaging.
- **Consistency drift:** across many sequential edits, identity can slowly shift; re-state "keep the same face" and verify.
- **Exact enforced resolutions/aspect handling in rtst are not documented here** — confirm live with `rtst model get nanobanana --json`.
- All Google image outputs carry an invisible SynthID watermark.
