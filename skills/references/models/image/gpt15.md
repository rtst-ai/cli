# GPT 1.5 — `gpt15`

**Provider:** OpenAI · **Underlying model:** OpenAI GPT Image (gpt-image-1 class) ·
**Modality:** image editing / text-to-image

OpenAI's GPT-Image model: exceptional prompt adherence, reliable in-image text, and strong world knowledge, so it "understands" briefs (ads, UI mockups, infographics) rather than just pattern-matching a style. Reach for it when instruction-following and legible text matter more than raw photographic polish. Use `gpt20` (GPT Image 2) for the newest, higher-fidelity generation.

## rtst usage

```bash
rtst image create gpt15 --prompt "..." [--image <file>] [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)

- **Input images:** `--image <file-or-url>` (repeatable, auto-uploaded) for editing / reference / multi-image compositing.
- `--samples N` (1–10), optional `--grid 2x2|3x3` (samples 1 only), `--width`/`--height`.
- Re-check the live, authoritative parameter set with `rtst model get gpt15 --json`.

## How to prompt it

GPT-Image follows structured, explicit instructions very literally — write it like a spec, not a mood board.

- **Order the prompt:** `background/scene → subject → key details → constraints/exclusions`. For complex requests use short labeled segments or line breaks instead of one long paragraph.
- **State the intended use** ("a Facebook ad", "a mobile UI mockup", "an infographic"). It sets the model's mode and polish level.
- **Text rendering is a strength.** Put the exact copy in quotes or ALL CAPS, specify font style/size/color/placement, and demand exactness — *"render verbatim, no extra characters, no reflow."* For tricky brand names or odd spellings, **spell them out letter-by-letter**.
- **Constraints / identity preservation:** say what must NOT change — *"no watermark", "no extra text", "preserve identity/geometry/layout"*. On edits: *"change only X, keep everything else the same,"* and repeat those preservation rules on each iteration to fight drift.
- **Multi-image workflows:** reference each input by index and role — *"Image 1: the product… Image 2: style reference… Apply Image 2's style to Image 1"* or *"put the bird from Image 1 onto the elephant in Image 2."*
- **Photorealism:** use photography language (lens type, aperture feel, lighting direction) and avoid overly "concept-art"/cinematic phrasing, which reads as stylized. For UI mockups, describe it as if the product already ships.
- **Iterate with small single-change follow-ups** rather than overloading one prompt.

## Example prompts

```bash
# 1. Text-forward marketing asset (exact copy + typography)
rtst image create gpt15 --prompt "A clean product ad for a coffee brand. Scene: warm cafe counter, soft morning light. Subject: a ceramic mug of latte, centered. Text: render \"MORNING RITUAL\" in a bold uppercase serif, top-center, dark brown, no extra characters. Constraints: no watermark, high contrast, negative space on the left." --wait --json

# 2. Edit that preserves identity
rtst image create gpt15 --prompt "Edit this photo: change only the wall color behind the person to deep teal. Preserve the subject's identity, pose, clothing, and the lighting and shadows. No extra text, no watermark." --image ./portrait.png --wait --json

# 3. Multi-image style transfer / compositing
rtst image create gpt15 --prompt "Image 1: a plain white sneaker product shot. Image 2: a graffiti-covered wall style reference. Apply Image 2's color palette and texture as the background scene for the sneaker from Image 1, keeping the sneaker's shape and logo unchanged." --image ./sneaker.png --image ./graffiti.jpg --samples 2 --wait --json
```

## Limitations & tips

- **Version mapping is unconfirmed.** rtst labels this "GPT 1.5" (`gpt15`) and the model catalog maps it to *OpenAI GPT Image (gpt-image-1)*. OpenAI's current lineup also includes `gpt-image-1.5`; whether rtst's `gpt15` wraps `gpt-image-1` or `gpt-image-1.5` is **inferred, not verified** — confirm with `rtst model get gpt15 --json`. The prompting advice above applies to the whole gpt-image-1.x family.
- Sizing: `--width <px>` / `--height <px>`, or `--param image_size=1K|2K|4K` for tier-based models (confirm supported values with `rtst model get <name> --json`).
- Very dense text layouts can still slip — keep strings strict, request high quality, and iterate with small wording tweaks.
- Strong on prompt adherence and text; for the most photorealistic faces/skin and the newest editing reliability, prefer `gpt20`.
- OpenAI enforces content policy (no real-person likeness abuse, restricted content); expect refusals on disallowed requests.
