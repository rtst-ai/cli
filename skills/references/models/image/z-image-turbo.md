# Z-Image Turbo — `z-image-turbo`
**Provider:** Alibaba Tongyi (Tongyi-MAI / Tongyi Lab) · **Underlying model:** Z-Image-Turbo (~6B S3-DiT, few-step distilled) · **Modality:** text-to-image ·
A fast, efficient ~6B open-weight text-to-image model distilled to generate high-quality photorealistic images in roughly 8 diffusion steps, with a standout strength in bilingual (Chinese + English) in-image text rendering.

## rtst usage
```bash
rtst image create z-image-turbo --prompt "..." [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)
- **NO image input — text-to-image only.** This model does not accept `--image`. It cannot do image-to-image, editing, inpainting, or variations. (The separate `Z-Image-Edit` variant handles editing, but it is a different model and is not exposed here.)
- `--prompt "..."` — the text prompt (required).
- `--samples N` — number of images to generate, 1-10 (optional).
- `--grid 2x2|3x3` — render a single grid image instead of one picture (only valid with `--samples 1`; other pairings are ignored by the API).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
- `--wait` — block until generation completes.
- `--json` — emit machine-readable JSON output.

## How to prompt it
Guidance below is drawn from the official model card and reputable prompt guides (cited in Limitations); tips marked *(inferred)* are reasonable extrapolations, not stated by sources.

- **Use positive, presence-based phrasing only.** Z-Image-Turbo runs at guidance_scale = 0.0 (no classifier-free guidance), so **negative prompts are effectively ignored**. Every constraint must be stated as something that IS in the frame, not something to avoid. (Cited.)
- **Lead with photography vocabulary for realism.** Named gear and film stocks push output from "plastic" toward documentary-authentic: e.g. "point-and-shoot film camera," "Hasselblad medium format," "Kodak Portra 400," "Cinestill 800T," plus texture cues like "visible pores," "fine grain," "slight motion blur." Prefer these over vague adjectives like "realistic." (Cited.)
- **Render text by wrapping the exact words in double quotes.** In-image typography is a signature strength — great for posters, signage, logos, and bilingual (Chinese/English) content. Put the literal string in quotes inside your prompt. (Cited.)
- **Structure the prompt:** subject (with concrete, non-idealized detail) → scene/setting → composition (camera angle, lens, framing) → lighting (direction, color temperature, time of day) → a single coherent style family (photoreal OR painterly OR cinematic — do not stack conflicting styles). (Cited.)
- **Write natural language, not tag soup.** Midjourney-style comma tag lists underperform; full descriptive sentences work better here. (Cited.)
- **Optionally draft manually, then have an LLM expand it** into a rich, detailed description — the model rewards specificity. (Cited.)

## Example prompts
```bash
rtst image create z-image-turbo --prompt "A weathered fisherman in his sixties mending a net on a wooden dock at dawn, shot on a point-and-shoot film camera with Kodak Portra 400, soft directional side light, visible skin pores and fine film grain, documentary photography, 3/4 portrait framing" --wait --json
```
```bash
rtst image create z-image-turbo --prompt "Vintage coffee-shop poster, warm cream background, bold serif title reading \"MORNING BREW\" with a smaller line reading \"手冲咖啡\" beneath it, flat illustration style, centered composition, high legibility" --samples 4 --wait --json
```
```bash
rtst image create z-image-turbo --prompt "Neon-lit Tokyo alley at night after rain, reflections on wet asphalt, cinematic anamorphic look, teal and magenta color grade, a lone figure with an umbrella, shallow depth of field" --wait --json
```

## Limitations & tips
- **No image input of any kind.** Text-to-image only — no editing, inpainting, reference images, or variations. Do not pass `--image`. (Cited: model card notes editing is only via the separate Z-Image-Edit variant.)
- **Negative prompts do nothing** (guidance_scale = 0.0). Rephrase avoidance as positive presence. (Cited.)
- **Fixed few-step inference** (~8 NFEs, distilled Turbo variant); the underlying step count is not user-adjustable and this model is not intended for fine-tuning. Speed is a headline feature — sub-second latency on datacenter GPUs and it fits within ~16GB consumer VRAM. (Cited.)
- **High quality, lower diversity.** The model card explicitly notes very high visual quality but relatively low output diversity — reruns of the same prompt can look similar. Vary wording (or use `--samples`) for more spread. (Cited.)
- **Sources conflict on ideal prompt length.** The official-adjacent guidance (Hugging Face discussion) says Z-Image-Turbo "works best with long and detailed prompts," with an effective text-attention cap around ~512 tokens; a secondary prompt guide (Fliki) recommends keeping to ~3-5 strong visual concepts / ~75-100 tokens and warns quality drifts as prompts grow. Practical read *(inferred)*: be detailed and specific, but keep the concepts coherent and non-contradictory rather than piling on length for its own sake. Test both ends for your use case.
- **Best around 1024x1024.** Square/near-square resolutions are the tuned sweet spot; extreme aspect ratios are less reliable *(inferred from the cited 1024x1024 recommendation)*.
- **Strong at hands and legible text** relative to older open models, per the model card and secondary coverage — but no model is perfect; verify fine text and complex hand poses.

Sources: [Tongyi-MAI/Z-Image-Turbo model card (Hugging Face)](https://huggingface.co/Tongyi-MAI/Z-Image-Turbo), [Z-Image paper (arXiv 2511.22699)](https://huggingface.co/papers/2511.22699), [Fliki prompting guide](https://fliki.ai/blog/z-image-turbo-prompting-guide), [HF prompting-guide discussion](https://huggingface.co/Tongyi-MAI/Z-Image-Turbo/discussions/8).
