# GPT 2.0 — `gpt20`

**Provider:** OpenAI · **Underlying model:** OpenAI GPT Image 2 (gpt-image-2) ·
**Modality:** image editing / text-to-image

OpenAI's newest and most capable image model, positioned as the production default: superior photorealism, more reliable editing, stronger text rendering, and robust facial/identity preservation. Output is high-fidelity by default. Reach for it for customer-facing, brand-sensitive, and text-heavy work; use `gpt15` when you need the older gpt-image-1.x behavior or lower cost.

## rtst usage

```bash
rtst image create gpt20 --prompt "..." [--image <file>] [--samples N] --wait --json
```

## Parameters (enforced by the rtst API)

- **Input images:** `--image <file-or-url>` (repeatable, auto-uploaded) for editing / reference / multi-image compositing.
- `--samples N` (1–10), optional `--grid 2x2|3x3` (samples 1 only), `--width`/`--height`.
- Re-check the live, authoritative parameter set with `rtst model get gpt20 --json`.

## How to prompt it

Prompt it like `gpt15` — explicit, structured, spec-style — but it follows complex, multi-part briefs more reliably and needs less hand-holding on fidelity.

- **Order the prompt:** `background/scene → subject → key details → constraints/exclusions`. Use short labeled segments or line breaks for complex requests, and state the intended use (ad, UI mock, infographic).
- **Text rendering:** crisp lettering and consistent layout. Put exact copy in quotes/ALL CAPS, specify font/size/color/placement, and spell out tricky brand names letter-by-letter. It handles structured visuals (infographics, diagrams) well.
- **Identity preservation is built-in.** gpt-image-2 keeps faces/identity stable across edits and multi-step workflows, and input fidelity is high by default (no separate low/high fidelity toggle needed on the raw model). Still, on edits say *"change only X, keep everything else,"* and restate preservation rules across iterations.
- **Photorealism:** lean on photography language (lens, aperture feel, lighting direction); avoid concept-art/cinematic phrasing when you want a real photo. Describe UI mockups as shipping products.
- **Multi-image workflows:** reference each input by index and role, and describe how they interact ("apply Image 2's style to Image 1", "composite the subject from Image 1 into Image 2").
- **Quality/latency:** the raw model exposes `low`/`medium`/`high` quality; `low` performs surprisingly well for many uses. Whether rtst surfaces this is API-dependent — check `rtst model get`.

## Example prompts

```bash
# 1. Brand-sensitive photoreal ad with exact text
rtst image create gpt20 --prompt "A premium skincare ad. Scene: soft-lit marble vanity, morning light from the left. Subject: a frosted-glass serum bottle, centered, shallow depth of field. Text: \"RENEW\" in a thin elegant uppercase serif, bottom-center, warm gold, rendered verbatim. Constraints: photorealistic, no watermark, no extra text." --wait --json

# 2. Identity-preserving edit
rtst image create gpt20 --prompt "Edit this portrait: change the outfit to a charcoal tailored suit and place the person in a modern glass-walled office. Preserve the person's face, identity, hairstyle, and expression exactly. Match natural lighting and shadows. No watermark." --image ./headshot.jpg --wait --json

# 3. Infographic / structured visual with multi-image references
rtst image create gpt20 --prompt "Design a clean 3-step onboarding infographic (UI mockup style, as if shipping). Use Image 1 as the brand color palette. Three labeled cards left-to-right: \"1. Sign up\", \"2. Connect\", \"3. Launch\", each with a simple line icon. Bold sans-serif, high contrast, generous spacing, no watermark." --image ./palette.png --samples 2 --wait --json
```

## Limitations & tips

- **Recent model, evolving docs.** gpt-image-2 specifics (high-default fidelity, flexible sizing up to ~3840px edge with ratio/pixel caps, quality tiers) come from OpenAI's current cookbook guidance and may change; the exact behavior rtst exposes is enforced by the API — verify with `rtst model get gpt20 --json`.
- The rtst "GPT 2.0" → gpt-image-2 mapping is consistent across the task brief, the model catalog, and OpenAI's naming, so it's stated with confidence (unlike `gpt15`).
- Costs more than `gpt15` for high-volume work; use lower quality/fewer samples when fidelity isn't critical.
- OpenAI content policy applies (real-person likeness limits, restricted content) — expect refusals on disallowed prompts.
- Even with strong text, very dense paragraphs can occasionally slip; keep copy strict and iterate.
