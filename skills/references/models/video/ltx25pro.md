# LTX 2.5 Pro (`ltx25pro`)
**Provider:** Lightricks (served via ModelsLab) · **Underlying model:** LTX 2.5 Pro (LTX audio-video DiT) · **Modality:** Text-to-video and image-to-video (first frame) · **Audio:** Yes (optional native, synchronized audio)

The successor to `ltx23` in rtst: the same narrative-prompted LTX audio-video model, now with **portrait (9:16)** as well as landscape, at HD or Full HD, in fixed 6/8/10 s clips. Reach for it for fast, good-looking single shots with optional native sound, especially vertical social clips. Use `ltx23` if you need 2K/4K landscape output, and `seedance205`/`wan30` for references or longer clips.

## rtst usage
```bash
rtst video create ltx25pro --prompt "..." --aspect-ratio 9:16 --duration 8 --resolution 1080p --audio --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `16:9`, `9:16`
- **Resolutions:** `720p`, `1080p`
- **Durations (s):** `6`, `8`, `10`
- **Audio:** Yes, off by default; enable with `--audio`.
- **Image input:** `--first-frame <file>` only (image-to-video). No last frame, no reference images, videos or audio, and no `{{...}}` placeholders (the model would render them as text). Local files auto-upload; URLs pass through.

## How to prompt it
LTX reads prompts as **narrative**, not structured data. Write one flowing paragraph in **present tense**, roughly 4 to 8 sentences, scaled to the duration (fewer for 6 s, more for 10 s).

- **Lead with the main action**, then add specific movements and gestures, the subject's appearance, the background and setting, camera angle and movement, lighting and color.
- **Physical cues, not emotion labels:** "her eyes lower and her jaw tightens" animates better than "she is sad".
- **Camera with an end-state:** "the camera pushes in slowly, settling on a close-up of his hands". It understands tracking, panning, tilting, crane, dolly, handheld and static shots.
- **Audio in-line (with `--audio`):** put spoken words in quotes and give the voice a quality ("a low, gravelly voice says..."); name ambience and music explicitly.
- **Image-to-video:** describe **motion and what changes**, not what is already visible in the frame. Match `--aspect-ratio` to the image's orientation.
- **Vertical framing:** for 9:16, compose for a tall frame: a single subject, centered, with vertical moves (tilt up, crane down) reading better than wide lateral pans.

## Example prompts
```bash
# 1. Vertical social clip with sound
rtst video create ltx25pro --prompt "A barista pours steamed milk into a cup of espresso, drawing a slow rosette as the foam swirls into shape. Her tattooed forearm moves in small steady arcs while the cafe behind her softly blurs. The camera starts tight on the cup and tilts up slowly, settling on her focused face. Warm morning window light, creamy tones. The hiss of the steam wand and quiet indie music fill the room." --aspect-ratio 9:16 --duration 8 --resolution 1080p --audio --wait --json

# 2. Landscape dialogue beat
rtst video create ltx25pro --prompt "In a dim garage workshop a mechanic wipes his hands on a rag and turns toward the camera as it pushes in, settling on a medium close-up. In a calm, gravelly voice he says, \"She'll run. Just not today.\" A single hanging bulb sways, throwing moving shadows across the tools on the wall, and rain drums on the metal roof." --aspect-ratio 16:9 --duration 6 --resolution 1080p --audio --wait --json

# 3. Animate a still (first frame), silent, cheaper 720p draft
rtst video create ltx25pro --first-frame ./mountain-lake.jpg --prompt "Wind ripples across the lake surface and low clouds drift past the peaks; the camera glides forward slowly over the water toward the far shore." --aspect-ratio 16:9 --duration 6 --resolution 720p --wait --json
```

## Limitations & tips
- Durations are fixed at 6, 8 or 10 s; use those exact values.
- No 2K/4K here (use `ltx23` for landscape up to 2160p).
- After a 9:16 or 720p job, check the output dimensions in the result; if it does not match what you asked for, report it and fall back to 16:9 at 1080p.
- Text and logos render unreliably; put them in the first frame instead.
- Complex multi-person physics and crowded scenes break down; keep one clear main action.
- Preview spend with `--estimate` on your exact command; resolution and audio can change the price.
