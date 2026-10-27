# OmniHuman 2.0 (`omnihuman20`)
**Provider:** BytePlus (ByteDance) · **Underlying model:** OmniHuman 2.0 · **Modality:** Audio-driven talking avatar (one image + one speech clip → video) · **Audio:** Yes (the output carries your reference audio)

ByteDance's audio-driven human animation model: give it one photo of a person and a speech clip, and it animates that person speaking the audio, with lip sync, head motion, facial expression and natural body gestures. An optional prompt directs the scene, movement and camera. Reach for it for presenters, explainers, spokesperson clips, dubbed characters and podcasts-to-video, up to 5 minutes in one job. For a generated scene where people merely talk, use `seedance205` or `wan30` with `--audio` instead.

## rtst usage
```bash
# Preview the cost first (measures the audio)
rtst video create omnihuman20 --reference-audio ./speech.mp3 --estimate --json

# Generate
rtst video create omnihuman20 --reference-image ./portrait.png --reference-audio ./speech.mp3 \
  --prompt "speaks warmly to the camera with small hand gestures, slow push-in" --wait --json
```

## Parameters (enforced by the rtst API)
- **Image input:** exactly one `--reference-image` (the person to animate; local file, URL, or existing photo id). jpeg, png, webp, bmp, tiff, gif, heic or heif; under 30 MB; 300 to 6000 px per side; width/height ratio between 0.4 and 2.5. No `--first-frame`/`--last-frame`.
- **Audio input:** exactly one `--reference-audio` (the speech; local file or URL, not an audio-media id). mp3 or wav, under 15 MB, 4 to 300 s. A long clip has to be mp3 to stay under 15 MB.
- **Durations (s):** none to choose. The video is exactly as long as the audio, and that length is what you pay for. Do not pass `--duration`.
- **Aspect ratios:** none to choose. The output takes the shape of the input image, so crop the portrait to the frame you want (e.g. 9:16 for vertical).
- **Resolutions:** `720p` (the only tier; no `--resolution` needed)
- **Audio:** the output carries the reference audio; no `--audio` flag needed.
- **Prompt:** optional, any length (no 10-word minimum). Plain words only, **no `{{img1}}`/`{{aud1}}` placeholders**. Languages: English, Chinese, Japanese, Korean, Spanish (Mexican), Indonesian.
- **Cost:** a flat rate per second of audio, rounded up to the whole second. Get the exact number with `rtst video create omnihuman20 --reference-audio ./speech.mp3 --estimate --json`.

## How to prompt it
The audio drives lips, timing and much of the expression; the prompt adds direction on top. Keep it short and concrete:

- **Delivery and emotion:** `speaks enthusiastically`, `calm and reassuring`, `serious, measured tone`, `laughs softly between sentences`.
- **Body and gestures:** `small natural hand gestures`, `leans slightly toward the camera`, `nods while speaking`, `holds a coffee mug`. Keep gestures modest; large actions fight the lip sync.
- **Camera:** one simple move: `static medium shot`, `slow push-in`, `gentle handheld feel`.
- **Scene and light:** a light touch of setting works best when it matches the photo: `soft studio light`, `office background slightly blurred`.

**Inputs matter more than the prompt:**
- **Image:** one clearly visible person, front-facing or three-quarter, face unobstructed (no hands, hair or sunglasses over the mouth), even lighting, sharp focus. Head-and-shoulders to half-body framing gives the best lip sync; a half-body or wider photo leaves room for hand gestures. Illustrated and stylized characters work too, provided the face is clear.
- **Audio:** clean, close-miked speech with no background music, and little silence at the start. Music or overlapping voices reduce lip-sync accuracy.

## Example prompts
```bash
# 1. Vertical spokesperson clip (use a 9:16 portrait)
rtst video create omnihuman20 --reference-image ./host-vertical.jpg --reference-audio ./promo.mp3 \
  --prompt "speaks energetically to the camera, smiling, with small open-hand gestures; static medium close-up, bright soft light" --wait --json

# 2. Calm explainer, no prompt (the audio drives everything)
rtst video create omnihuman20 --reference-image ./doctor.png --reference-audio ./explainer.wav --wait --json

# 3. Illustrated character reading a story
rtst video create omnihuman20 --reference-image ./storyteller-illustration.png --reference-audio ./chapter1.mp3 \
  --prompt "a gentle storyteller speaking softly, occasional warm smile and slow nods, slow push-in, cozy lamp light" --wait --json
```

## Limitations & tips
- **Exactly one person, one image, one audio clip** per job. Two-person conversations need two jobs edited together.
- Cost grows with audio length (up to 300 s); always run the `--estimate` command first and trim silence from the audio.
- The reference image is content-moderated: photos of public figures are rejected, and the image, audio or prompt can be blocked by safety filters. A failed job is refunded automatically.
- Output is 720p only; upscale afterwards if needed.
- The prompt cannot override the audio: emotion words that contradict the voice (e.g. "angry" over a cheerful read) give mixed results.
