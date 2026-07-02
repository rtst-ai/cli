<!-- Template for a per-model reference doc. Keep it tight and practical. -->

# <Title> — `<rtst-model-name>`

**Provider:** <company> · **Underlying model:** <official model name/version> ·
**Modality:** <text-to-video / image-to-video / text-to-image / image editing> ·
**Audio:** <yes/no>

One or two sentences: what this model is good at and when to reach for it vs its siblings.

## rtst usage

```bash
rtst <video|image> create <name> --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)

- **Aspect ratios:** <list>
- **Resolutions:** <list>
- **Durations (s):** <list>        <!-- video only -->
- **Audio:** <yes/no + how to enable: --audio>
- **Image input:** <first-frame / last-frame / reference images, or "reference image for editing">

## How to prompt it

- Prompt structure that works (subject → action → setting → camera/lighting → style).
- Motion / camera control keywords the model understands.
- Strengths (what it nails) and weaknesses (what to avoid or expect to fail).
- Any provider-specific prompt conventions (e.g. audio cues, negative prompts).

## Example prompts

```bash
# 1. <what it demonstrates>
rtst video create <name> --prompt "<full prompt>" --aspect-ratio 9:16 --duration 8 --resolution 1080p --wait --json
```

(2–3 concrete, copy-pasteable examples.)

## Limitations & tips

- Content-policy notes, common failure modes, resolution/duration trade-offs,
  credit cost sensitivity, and how it compares to the closest alternative model.
