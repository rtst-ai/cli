# Grok Image (Aurora) — `grok`
**Provider:** xAI · **Underlying model:** `grok-imagine-image` (Aurora lineage) · **Modality:** text-to-image & image editing / reference ·
xAI's photorealism-first image model. Built on the Aurora autoregressive mixture-of-experts architecture trained on billions of interleaved text+image examples, it stands out for real-world knowledge (recognizable people, places, brands, logos), strong in-image text rendering, and lifelike portraits — at the cost of a stricter content policy.

## rtst usage
```bash
rtst image create <name> --prompt "..." [--image <file>] [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)
- Input images: `--image <file-or-url>` (repeatable, auto-uploaded). Providing one or more images switches the model into edit/reference mode; the rtst API accepts **up to 6** reference images per request. Without `--image`, it runs pure text-to-image.
- `--samples N` (1–10) — number of variations from one prompt in a single call.
- `--grid 2x2|3x3` — render a single grid image instead of one picture (only valid with `--samples 1`; other pairings are ignored by the API).
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).

## How to prompt it
*(Prompting guidance below is synthesized from xAI's Aurora announcement and secondary prompt guides — CITED where noted, INFERRED where marked. Grok image is comparatively new, so treat specifics as directional.)*

- **Be concrete and descriptive.** xAI's guidance is to specify subject, style, lighting, composition, and mood rather than a bare noun — e.g. "a fluffy orange tabby on a windowsill, golden-hour light, bokeh background, photorealistic" beats "a cat." (CITED — xAI / secondary guides.)
- **Lean into its strengths.** Aurora is trained on real-world data and excels at photorealistic detail, real entities, and in-image **text/logos** — so name real places, brands, or exact signage/wording and it will usually render them faithfully. (CITED — Aurora announcement.)
- **Portraits and photography.** For realism, prompt like a photographer: camera/lens feel (`85mm portrait`, `wide-angle`), lighting (`soft window light`, `harsh noon sun`), depth of field, and film/color reference. (INFERRED from photoreal-model prompting norms.)
- **Text in images.** Put the exact words in quotes in the prompt (e.g. a poster reading "GRAND OPENING"); keep the string short for best fidelity. (INFERRED — Aurora is noted for text rendering but exact-string reliability drops with length.)
- **Editing / reference (`--image`).** Give a plain-language instruction describing the change ("replace the background with a snowy forest, keep the subject unchanged") or, with multiple images, how to combine them (subject from image 1, style from image 2). (CITED — xAI docs describe natural-language edits and multi-image composition.)
- **No negative-prompt field.** State what you *don't* want in the positive prompt ("empty street, no people") rather than expecting a separate exclusion parameter. (INFERRED — no negative-prompt param exposed by the API.)

## Example prompts
```bash
rtst image create grok --prompt "Editorial portrait of a woman in a red wool coat on a rainy Tokyo street at night, neon signs reflecting in wet pavement, shot on 85mm f/1.4, shallow depth of field, cinematic color, photorealistic" --param image_size=2K --samples 4 --wait --json
```

```bash
rtst image create storefront-sign --prompt "A cozy corner bakery at golden hour, warm interior glow, a hand-painted wooden sign above the door reading \"SUNRISE BAKERY\", people walking past, ultra-realistic street photography" --param image_size=2K --wait --json
```

```bash
rtst image create bg-swap --prompt "Keep the subject exactly as-is but replace the background with a misty pine forest at dawn, match the soft cool lighting to the new scene" --image ./portrait.jpg --samples 2 --wait --json
```

## Limitations & tips
- **Content policy is strict.** xAI applies moderation/content-policy review to Grok image requests, and rtst surfaces blocked results (internally logged as `grok_content_blocked`). Requests involving certain real-person, explicit, or otherwise disallowed content may return no image even when the API call succeeds. Expect more refusals here than on some other rtst image models.
- **Fine detail — hands.** The most widely reported Aurora weakness is anatomical detail, especially hands/fingers, which can render mangled or extra-digit. Regenerate (`--samples`) or crop/frame to avoid full-hand close-ups. (CITED — multiple reviews.)
- **`--image` editing is confirmed supported** by the rtst backend (up to 6 reference images via xAI's edit endpoint), so no uncertainty flag is needed — but multi-image *composition* fidelity is model-dependent and less predictable than single-image edits. (INFERRED for composition reliability.)
- **Aspect ratio isn't a direct rtst image flag** in this template — the API infers it from requested dimensions/defaults to `1:1`. If you need a specific ratio, bake framing intent into the prompt.
- **No seed/negative-prompt controls** are exposed; reproducibility across runs is not guaranteed.
- **Source caveat:** xAI's public prompt documentation for the image model is thin and several secondary guides conflate the browser Grok Imagine product with the API model. Model/architecture facts here are anchored to the xAI Aurora announcement and the rtst API implementation; stylistic prompt tips are best-practice inference.
