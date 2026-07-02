# MiniMax Hailuo 2.3 — `hailuo23`
**Provider:** MiniMax · **Underlying model:** `MiniMax-Hailuo-2.3` (text-to-video) / `MiniMax-Hailuo-2.3-Fast` (image-to-video) · **Modality:** Text-to-video & image-to-video · **Audio:** Native

Hailuo 2.3 is MiniMax's motion-and-physics specialist: it renders complex body movement, material deformation (fabric, hair, particles), and expressive faces with near-photoreal lighting. Choose it when the shot lives or dies on **believable movement**.

## rtst usage
```bash
rtst video create hailuo23 --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `16:9`, `9:16`
- **Resolutions:** `480p`, `720p`, `1080p`
- **Durations (s):** `6`, `10`
- **Audio:** Yes — enable with `--audio` (off by default).
- **Image input:** `--first-frame <file>` for image-to-video (start frame → motion). No last-frame or reference-image slot on this model. Local files auto-upload; URLs pass through.

## How to prompt it
Hailuo rewards **narrative, physically grounded** prompts over tag soup. Establish the story, then layer motion, camera, and mood.

- **Tell a mini-story, don't stack tags.** "A cyberpunk samurai sprints desperately through a rainy Neo-Tokyo market" beats "cyberpunk, rain, neon, samurai."
- **Describe *how* motion feels.** Use strong action verbs and adverbs: "the sports car aggressively accelerates, careening around the corner" outperforms "the car drives fast." "A chef gently places a dessert on a marble counter" gives the physics engine more to work with than "a chef with dessert."
- **Sequence with temporal markers.** Words like *then*, *as*, *meanwhile* guide the order of events across the clip.
- **Use real camera terms.** *Tracking shot, rack focus, dolly, crane, POV* — e.g. "a tracking shot follows the runner, rack focusing from leaves to her expression."
- **Trust the in-betweening.** Hailuo infers intermediate steps: "she picks up the coffee cup and drinks" auto-fills the grasp and tilt — you don't need to spell out every micro-motion.
- **Image-to-video: prompt only the delta.** Describe what *changes*, not what's already visible in the frame, and don't ask for a wide shot when the input is a close-up (it will hallucinate).

## Example prompts
```bash
# Text-to-video, physics-forward action, 10s
rtst video create hailuo23 --prompt "A gymnast explodes into a triple backflip off a wooden vault, chalk dust bursting from her hands, muscles taut, then sticks the landing with arms raised; low-angle tracking shot, warm arena spotlights, shallow depth of field." --aspect-ratio 16:9 --duration 10 --resolution 1080p --audio --wait --json
```

```bash
# Vertical character piece emphasizing expression, 6s
rtst video create hailuo23 --prompt "Close-up of an elderly fisherman as a slow smile spreads across his weathered face, wind tugging his gray hair and collar, salt spray catching the golden light; gentle handheld drift, cinematic grade." --aspect-ratio 9:16 --duration 6 --resolution 720p --audio --wait --json
```

```bash
# Image-to-video, prompt only the change, lightweight 480p draft
rtst video create hailuo23 --prompt "The still character slowly turns her head toward camera and her cloak billows as a gust sweeps through, embers drifting past; subtle push-in." --first-frame ./hero.png --aspect-ratio 9:16 --duration 6 --resolution 480p --wait --json
```

## Limitations & tips
- **Only 6s or 10s durations** and **16:9 / 9:16** aspect ratios in the rtst client — no 4s clips, no square/ultrawide.
- **Resolution nuance:** internally MiniMax renders "720p" as its 768P tier; native output tops out at 1080P, so for 4K you'd upscale externally (e.g. Topaz).
- **Audio is opt-in** via `--audio`.
- **Avoid instruction overload / conflicts** — extreme prompt density or contradictory directions can cause morphing or dropped actions.
- **On-screen text rendering is only moderate;** don't rely on it for legible signage or captions.
- **Image-to-video uses the `-Fast` variant** automatically — expect quick turnaround, and keep prompts to the delta as noted above.
- **Unverified:** provider credit cost, and whether every listed resolution is honored at both durations, are not enforced client-side — confirm against your account.
