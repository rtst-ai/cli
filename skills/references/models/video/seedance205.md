# Seedance 2.5 (`seedance205`)
**Provider:** BytePlus ModelArk (ByteDance Seed) · **Underlying model:** Seedance 2.5 · **Modality:** Text-to-video, image-to-video (first + last frame), multimodal reference (images, videos, audio), **video editing and video extension** · **Audio:** Yes (native audio-video joint generation, multilingual lip-sync)

The newest Seedance generation: the same multimodal-reference workflow as Seedance 2.0, but with much longer clips (up to 30 s), far larger reference budgets, and first-class **editing** and **extension** of an existing video. Reach for it for long multi-shot sequences, heavily referenced scenes (many characters, products, locations), or when you need to change or continue footage you already have. Use `seedance20` when you need 4K (2160p), and `seedance20fast`/`seedance20mini` for cheap short drafts.

## rtst usage
```bash
# Generate (text, frames, or references)
rtst video create seedance205 --prompt "..." --aspect-ratio 16:9 --duration 10 --resolution 720p --wait --json

# Edit an existing video: pass it with --reference-video, cite it as {{vid1}}, declare the task type
rtst video create seedance205 --reference-video ./clip.mp4 \
  --prompt "In {{vid1}}, replace the red car with a vintage blue convertible. Keep everything else the same." \
  --param video_task_type=video_editing --resolution 720p --wait --json

# Extend an existing video: --duration is the length to add
rtst video create seedance205 --reference-video ./clip.mp4 \
  --prompt "Continue {{vid1}}: the hiker reaches the ridge and turns to look at the valley below, camera slowly orbits her." \
  --param video_task_type=video_extension --duration 8 --resolution 720p --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `21:9`, `16:9`, `4:3`, `1:1`, `3:4`, `9:16` (frame, editing and extension jobs follow the input's shape instead; see below)
- **Resolutions:** `480p`, `720p`, `1080p` (no 4K; use `seedance20` for 2160p)
- **Durations (s):** `4` to `30` (any integer in range)
- **Audio:** Yes, enable with `--audio`. Reference audio turns it on automatically.
- **Image input:** `--first-frame <file>`, `--last-frame <file>` (frame interpolation), `--reference-image <file>` (repeatable, up to 30). Inputs may be local files, URLs, or existing photo ids; this model takes **photo ids, not URLs**, so the CLI uploads each input as a Photo automatically.
- **Video & audio references:** `--reference-video <file>` and `--reference-audio <file>` (each repeatable, up to 10; local files, URLs, or existing ids). Each clip 2 to 30 s, 30 s combined per type; videos under 100 MB, audio under 15 MB. Confirm the live limits with `rtst model get seedance205 --json` → `image_capabilities.reference_videos` / `reference_audios`.
- **Prompt placeholders (required for references):** `{{img1}}`, `{{img2}}`, ... (`--reference-image` order), `{{vid1}}`, ... (`--reference-video`), `{{aud1}}`, ... (`--reference-audio`); `{{first}}`/`{{last}}` name the frame flags. The CLI rewrites them. A reference the prompt never mentions anchors nothing.
- **Frames OR references, not both:** `--first-frame`/`--last-frame` cannot be combined with any reference image, video or audio in one job (the CLI stops you first).
- **Task type (`--param video_task_type=...`):** `video_generation` (default: a new video, even one that only *references* media), `video_editing` (change an existing video), `video_extension` (make an existing video longer). Editing and extension need a reference input, normally `--reference-video`. If you leave it out, rtst detects the intent from your prompt wording; declaring it is the deterministic option.
  - **Editing:** output length and shape match the source video. `--duration` and `--aspect-ratio` can be omitted and are ignored. Billed as the input video plus an output of the same length (rounded up to a whole second).
  - **Extension:** `--duration` is required and sets how much to add; the shape follows the source.
  - **First/last frame jobs:** the shape follows the frame image; `--duration` is still required.
- **Moderation:** reference media are content-moderated (public figures rejected); photos of people get an extra moderation pass on first use (~10 s), and the CLI waits for it.

## How to prompt it
Seedance 2.5 prompts like Seedance 2.0: structured, concrete, roughly 60 to 120 words for a single shot (more for a multi-shot sequence).

**Subject → Action → Environment → Camera → Style → Constraints**

- **Subject:** who/what, with concrete attributes. With references, name the role of each: "the woman from {{img1}} wearing the jacket from {{img2}}, in the kitchen from {{img3}}".
- **Action:** one clear present-tense verb per shot.
- **Camera:** one primary move per shot (push-in, pull-out, pan, tracking, orbit, aerial, handheld, locked-off). Keep camera motion and subject motion in separate clauses.
- **Style:** lighting first (the biggest quality lever), then lens, color and mood.
- **Multi-shot:** the 30 s ceiling makes real sequences possible. Describe shots in order ("Wide establishing shot... cut to a close-up... then a tracking shot..."), re-state key subject attributes at each cut, and keep to roughly one shot per 4 to 8 seconds.
- **Audio:** with `--audio`, describe the soundscape, music mood or dialogue in the prompt; put spoken lines in quotes. To sync to a track, attach it with `--reference-audio` and cite `{{aud1}}`.

**Editing:** keep it surgical. One change per job, and say what stays: `In {{vid1}}, <change>. Keep everything else the same.` Works for replacing or adding a subject or object, removing something, repairing a region, or replacing the audio or music.

**Extension:** describe what happens *next* (or before, for a backward extension: "extend {{vid1}} backward: ..."), keeping the same subject, setting and lighting wording as the source so the join is seamless.

## Example prompts
```bash
# 1. Long multi-shot sequence with sound
rtst video create seedance205 --prompt "Wide establishing shot: a lighthouse on a black-rock cliff at dusk, waves exploding below. Cut to a medium shot: the keeper, an old man in a navy wool coat, climbs the spiral stairs with a lantern, slow tracking shot from behind. Cut to a close-up as he lights the lamp and warm light floods his face. Moody teal-and-amber grade, telephoto lens, howling wind and crashing surf, low cello drone." --aspect-ratio 21:9 --duration 20 --resolution 1080p --audio --wait --json

# 2. Multi-reference scene: character + product + location
rtst video create seedance205 \
  --reference-image ./model.png --reference-image ./sneaker.png --reference-image ./rooftop.jpg \
  --prompt "The woman from {{img1}} laces up the sneaker from {{img2}} on the rooftop from {{img3}}, then jogs toward the skyline. Camera starts on a close-up of the shoe, then pulls out to a wide tracking shot. Golden-hour backlight, warm film grain, upbeat electronic music." \
  --aspect-ratio 9:16 --duration 12 --resolution 720p --wait --json

# 3. Edit existing footage
rtst video create seedance205 --reference-video ./street.mp4 \
  --prompt "In {{vid1}}, remove the parked scooter on the left side of the frame. Keep everything else the same." \
  --param video_task_type=video_editing --resolution 720p --wait --json
```

## Limitations & tips
- **Prototype at 480p, finish at 1080p:** price scales strongly with resolution and length (Seedance 2.x is token-priced). Preview with `--estimate` on your exact command. For editing and extension jobs, the estimate prices the `--duration` you pass and does not include the input video, so treat it as a floor.
- Longer is riskier: clips past 15 s raise the chance of identity drift and flicker. Use reference images for every recurring character and re-state attributes at each cut.
- Editing wording on a request **without** a reference input is treated as normal generation.
- For one-change-at-a-time edits at a fixed 720p with an even simpler instruction style, `geminiomniflash` is the alternative; Seedance 2.5 adds extension, many references, and up to 1080p.
- 4K is not available here; use `seedance20` for 2160p (15 s max).
