# Wan 3.0 (`wan30`)
**Provider:** Alibaba (Model Studio, Tongyi Wanxiang) · **Underlying model:** Wan 3.0 (all-in-one video model) · **Modality:** Text-to-video, image-to-video (first + last frame), reference-to-video (images, videos, audio) · **Audio:** Yes (native, synchronized dialogue, SFX and music)

Alibaba's all-in-one Wan model: one model covers text-to-video, first/last-frame animation and multimodal reference generation, with native sound and clips up to 30 s at up to 1080p. It is a strong, lower-cost alternative to `seedance205` for long, referenced, sound-on clips. Reach for it over `wan26` when you need references (characters, products, a voice or a music track), longer clips, or last-frame control.

## rtst usage
```bash
rtst video create wan30 --prompt "..." --aspect-ratio 16:9 --duration 10 --resolution 1080p --audio --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `16:9`, `9:16`, `1:1`, `4:3`, `3:4`
- **Resolutions:** `480p`, `720p`, `1080p`
- **Durations (s):** `2` to `30` (any integer in range)
- **Audio:** Yes, enable with `--audio`. Reference audio turns it on automatically. For a guaranteed silent clip pass `--param audio=false`.
- **Image input:** `--first-frame <file>`, `--last-frame <file>` (first-to-last interpolation), `--reference-image <file>` (repeatable, up to 10). Inputs may be local files, URLs, or existing photo ids; this model takes **photo ids, not URLs**, so the CLI uploads each input as a Photo automatically.
- **Video & audio references:** `--reference-video <file>` and `--reference-audio <file>` (each repeatable, up to 5; local files, URLs, or existing ids). Per-clip and combined duration limits are in `rtst model get wan30 --json` → `image_capabilities.reference_videos` / `reference_audios`. With reference video, **input video length plus output `--duration` must fit in 30 s**.
- **Prompt placeholders (required for references):** `{{img1}}`, `{{img2}}`, ... (`--reference-image` order), `{{vid1}}`, ... (`--reference-video`), `{{aud1}}`, ... (`--reference-audio`); `{{first}}`/`{{last}}` name the frame flags. The CLI rewrites them. Each type is numbered separately, so `{{img1}}` and `{{vid1}}` coexist. A reference the prompt never mentions anchors nothing.
- **Frames OR references, not both:** `--first-frame`/`--last-frame` cannot be combined with any reference image, video or audio in one job (the API rejects the request).
- Reference videos are content-moderated (public figures rejected).

## How to prompt it
Wan responds best to a director-style paragraph:

**Subject (with description) → Scene → Motion → Camera / shot language → Lighting & style → Sound**

- **Subject:** concrete appearance and wardrobe. With references, give each one a role: "the man from {{img1}} holds the bottle from {{img2}}"; "the woman moves like the dancer in {{vid1}}"; "speaking in the voice of {{aud1}}".
- **Motion:** specific verbs and pacing (`slowly`, `suddenly`, `gently`); describe one main action per shot.
- **Shot language:** Wan understands film vocabulary well: shot size (`extreme close-up`, `medium shot`, `wide shot`), angle (`low angle`, `over-the-shoulder`, `top-down`), and moves (`push in`, `pull back`, `pan left`, `tracking shot`, `orbit`, `handheld`, `static shot`).
- **Multi-shot:** describe shots in order, optionally with rough timings ("Shot 1 (0 to 4 s): ... Shot 2 (4 to 9 s): ..."). Keep the subject description consistent across shots.
- **Lighting & style:** time of day, light quality (`soft window light`, `hard rim light`, `neon`), color grade, film or animation style.
- **Sound:** with audio on, describe ambience, SFX and music; write dialogue in quotes with who speaks it ("she says: \"We're late.\""). Wan lip-syncs well in English and Chinese.

## Example prompts
```bash
# 1. Long text-to-video with dialogue
rtst video create wan30 --prompt "Medium shot in a cozy ramen bar at night, steam rising from bowls. An elderly chef in a white headband slides a bowl to a young office worker and says: \"Eat while it's hot.\" She smiles and breaks her chopsticks. Slow push in toward the counter. Warm tungsten light, shallow depth of field, rain ticking on the window, soft jazz in the background." --aspect-ratio 16:9 --duration 12 --resolution 1080p --audio --wait --json

# 2. First-to-last frame transition
rtst video create wan30 --first-frame ./sketch.png --last-frame ./render.png \
  --prompt "The pencil sketch in {{first}} gradually fills with color and depth until it becomes the finished painting in {{last}}. Static shot, smooth continuous transformation, soft studio light." \
  --aspect-ratio 4:3 --duration 6 --resolution 720p --wait --json

# 3. Character + voice reference
rtst video create wan30 --reference-image ./host.png --reference-audio ./intro.mp3 \
  --prompt "The presenter from {{img1}} stands in a bright modern studio and delivers the lines from {{aud1}} to camera, natural hand gestures. Medium shot, slow push in, soft key light, clean corporate look." \
  --aspect-ratio 9:16 --duration 10 --resolution 1080p --wait --json
```

## Limitations & tips
- Prototype at 480p or 720p and short durations, then re-run the winner at 1080p and full length; cost scales per second and with resolution. Preview with `--estimate` on your exact command.
- Long clips (20 to 30 s) raise the chance of drift; anchor recurring characters with `--reference-image` and keep their description identical in every shot.
- Pick one route per job: frames (precise start/end composition) or references (identity, product, voice, motion). To combine them, generate with references first, then use a frame from that result in a second job.
- Compared with `seedance205`: Wan 3.0 is cheaper per second and accepts shorter clips (from 2 s); Seedance 2.5 offers editing/extension, more references, and 21:9.
