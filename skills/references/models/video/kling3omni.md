# Kling 3 Omni — `kling3omni`

**Provider:** Kuaishou (Kling AI) · **Underlying model:** Kling Video 3.0 Omni
(a.k.a. Kling O3) · **Modality:** unified multimodal video — text-, image-, and
**video-reference**-to-video (first + last frame) · **Audio:** yes (native
multi-character audio + voice locking)

Omni is the premium, unified sibling of `kling3`: it treats text, images, video,
and audio as equal inputs and adds **reference-to-video** control. Upload a short
reference clip of a character and it extracts both appearance *and* voice, then
replicates them consistently across new scenes (Elements 3.0 / Omni Edit). Reach
for it when you need strong reference consistency, character voice locking, or
video-driven generation; use base `kling3` when you just need directable T2V/I2V
at lower cost.

## rtst usage

```bash
rtst video create <name> --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)

- **Aspect ratios:** `16:9`, `9:16`, `1:1`
- **Resolutions:** `720p`, `1080p`, `2160p` (4K)
- **Durations (s):** `3`–`15`
- **Audio:** yes — enable with `--audio` (native multi-character audio, voice lock)
- **Image input:** `--first-frame <file>`, `--last-frame <file>`, and
  `--reference-image <file>` (repeatable, up to 7) for character/element
  references. Inputs may be local files, URLs, or existing photo ids; this model
  takes **photo ids, not URLs**, so the CLI uploads each input as a Photo
  automatically.
- **Prompt placeholders (required for references):** mention each reference in
  the prompt — `{{img1}}`, `{{img2}}`, ... for `--reference-image` order;
  `{{first}}`/`{{last}}` for the frame flags. E.g. `"the character from {{img1}}
  wearing the outfit from {{img2}}"`. Unmentioned references anchor nothing.
  Content-moderated (public figures rejected).

## How Omni differs from base Kling 3.0

- **Reference-to-video:** built on the Kling O1 architecture, Omni accepts
  reference videos and multiple reference images and stays more faithful to them
  than base 3.0's reference handling.
- **Character voice locking:** extracts and reuses a character's voice, not just
  their look — key for multi-shot dialogue where a person recurs.
- **Omni Edit:** source-video editing / element replacement in a single model.
- **Cost:** premium tier — its cost-per-second is aligned with other top-tier
  foundation models, so prefer it when reference fidelity actually matters.

## How to prompt it

Everything in the `kling3` guide applies (shot-order prompts, explicit camera
vocabulary, multi-shot storyboards, `[Name, tone]: "line"` dialogue). Additionally:

- **Name your references.** When you pass `--reference-image` for a character or
  object, refer to it by a consistent name in the prompt (e.g. "Kira, the woman
  from the reference") so Omni binds appearance/voice to the right subject.
- **Describe the delta, not the reference.** With a reference video or first
  frame, prompt what *changes* — new setting, action, camera — and let Omni carry
  identity and voice forward.
- **Lock voices explicitly.** In multi-character audio, keep one label per speaker
  and describe tone once; Omni will hold that voice across shots.

## Example prompts

```bash
# 1. Reference-image character carried into a new scene, 4K
rtst video create hero-desert --prompt "Kira, the woman from the reference, strides across a wind-swept dune at dusk; tracking shot from her left, sand streaming off the ridge, cool blue light fading to amber" --reference-image ./kira.png --aspect-ratio 16:9 --duration 8 --resolution 2160p --wait --json

# 2. Multi-shot dialogue with two locked voices, vertical
rtst video create interview --prompt "Shot 1, medium close-up of Devi in a sunlit studio. [Devi, calm measured voice]: \"Let's begin.\" Shot 2, shot-reverse-shot on Owen. [Owen, nervous quick voice]: \"Where do I start?\"" --reference-image ./devi.png --reference-image ./owen.png --aspect-ratio 9:16 --duration 12 --resolution 1080p --audio --wait --json

# 3. First+last frame guided motion
rtst video create product-turn --prompt "The camera arcs around the sneaker on a rotating pedestal, studio softboxes glinting off the sole, settling on a centered hero angle" --first-frame ./front.png --last-frame ./hero.png --aspect-ratio 1:1 --duration 6 --resolution 1080p --wait --json
```

## Limitations & tips

- **Premium cost:** reserve Omni for jobs that genuinely need reference fidelity
  or voice locking; base `kling3` is cheaper for plain T2V/I2V.
- **Reference quality matters:** clean, well-lit reference frames/clips of a single
  clear subject give the strongest identity transfer.
- **Video-reference input** is Omni's headline feature but the newest; results can
  vary with source-clip length and framing — iterate.
- Model naming ("Omni" / "O3") and some feature limits are very new and vary
  across third-party docs; treat capability claims as directional and confirm the
  enforced parameters with `rtst model get kling3omni --json`.
