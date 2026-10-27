# MiniMax H3 (`minimaxh3`)
**Provider:** MiniMax (served via ModelsLab) · **Underlying model:** MiniMax H3 (Hailuo line) · **Modality:** Text-to-video, image-to-video (first frame, first + last frame), reference-to-video (images, videos, audio) · **Audio:** Yes, always (every clip comes back with a soundtrack)

MiniMax's reference-driven successor to the Hailuo models: the same strength in believable body motion and physics, now with multi-reference input (characters, products, styles, a motion clip, a voice or music track). Reach for it for motion-heavy shots that must keep a specific person or product on model, at a single 768p tier. Use `hailuo23` for plain text/image-to-video, `wan30` or `seedance205` when you need 1080p, more aspect ratios, or longer clips.

## rtst usage
```bash
rtst video create minimaxh3 --prompt "..." --aspect-ratio 16:9 --duration 6 --resolution 768p --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `16:9`, `9:16`. The model decides the final shape itself: with an image it follows the input image, so crop your images to the shape you want.
- **Resolutions:** `768p` only (`720p` is accepted as an alias for the same tier)
- **Durations (s):** `5`, `6`, `7`, `8`, `9`, `10`, `11`, `12`, `15`
- **Audio:** always generated; there is no way to turn it off, and `--audio` changes nothing. Steer it from the prompt.
- **Image input:** `--first-frame <file>`, `--last-frame <file>`, `--reference-image <file>` (repeatable, up to 8). Inputs may be local files, URLs, or existing photo ids; the CLI uploads local files automatically.
- **Video & audio references:** `--reference-video <file>` and `--reference-audio <file>` (each repeatable, up to 2; local files, URLs, or existing ids). At most 12 media files per job in total. Audio clips: roughly 2 to 15 s each, 15 s combined (not checked before submission, so stay inside it). Check live limits with `rtst model get minimaxh3 --json`.
- **Reference audio cannot be the only reference:** pair `--reference-audio` with at least one `--reference-image` or `--reference-video`.
- **Frames and references:** unlike Seedance 2.x and Wan 3.0, a `--first-frame` **can** be combined with references. A `--first-frame` + `--last-frame` pair is its own mode and takes no references.
- **Prompt placeholders (required for references):** `{{img1}}`, `{{img2}}`, ... (`--reference-image` order), `{{vid1}}`, ... (`--reference-video`), `{{aud1}}`, ... (`--reference-audio`); `{{first}}`/`{{last}}` name the frame flags. The CLI and API rewrite them to the model's own labels (a first frame counts as an image, so numbering is handled for you). A reference the prompt never mentions anchors nothing.

## How to prompt it
- **Structure:** subject → action (with physical detail) → setting → camera → lighting/style → sound. 40 to 100 words is the sweet spot.
- **Motion is the strength:** describe *how* things move: weight shifts, cloth and hair reacting, impacts, liquids, particles. "She spins, her pleated skirt flaring out and settling" beats "she dances".
- **Reference roles:** say what each reference contributes. Characters: "the boxer from {{img1}}". Products: "holding the can from {{img2}}, label facing camera". Style: "in the painterly style of {{img3}}". Motion: "copying the choreography in {{vid1}}". Sound: "to the beat of {{aud1}}" or "speaking with the voice in {{aud1}}".
- **Camera:** one main move in plain language (`slow push in`, `tracking shot following her`, `orbit around`, `static shot`). Earlier Hailuo models also accepted bracketed commands such as `[Push in]`; plain words are the safe choice here.
- **Sound:** since every clip has audio, always say what it should be (ambience, SFX, music mood, or quoted dialogue). Otherwise you get a generic bed.

## Example prompts
```bash
# 1. Text-to-video, motion-heavy
rtst video create minimaxh3 --prompt "A parkour runner in a grey hoodie sprints across a rooftop, vaults a ventilation unit and lands in a roll, gravel scattering. Tracking shot alongside him at waist height. Overcast daylight, gritty desaturated grade. Sound of footsteps, heavy breathing and city traffic far below." --aspect-ratio 16:9 --duration 6 --resolution 768p --wait --json

# 2. Character + product references
rtst video create minimaxh3 --reference-image ./athlete.png --reference-image ./bottle.png \
  --prompt "The athlete from {{img1}} finishes a sprint on a track at sunrise, stops, and drinks from the bottle from {{img2}}, label toward the camera. Slow push in to a medium close-up. Warm backlight, lens flare, energetic synth music." \
  --aspect-ratio 9:16 --duration 8 --resolution 768p --wait --json

# 3. Image + music: audio needs an image or video alongside
rtst video create minimaxh3 --reference-image ./dancer.png --reference-audio ./track.mp3 \
  --prompt "The dancer from {{img1}} performs a fluid contemporary routine in an empty warehouse, moving to the rhythm of {{aud1}}. Wide static shot, dusty shafts of light through high windows." \
  --aspect-ratio 16:9 --duration 10 --resolution 768p --wait --json
```

## Limitations & tips
- Single 768p tier; upscale afterwards if you need 1080p delivery.
- Aspect ratio is decided by the model, so match your first frame or main reference image to the target shape.
- Durations jump from 12 to 15 s (13 and 14 are not offered).
- Keep the reference count modest (2 to 4) for the most faithful identity; many references dilute each one.
- Preview spend with `--estimate` on your exact command.
