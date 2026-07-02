# Google Veo 3.1 — `veo31`
**Provider:** Google DeepMind (via Vertex AI) · **Underlying model:** `veo-3.1-fast-generate-001` · **Modality:** Text-to-video & image-to-video · **Audio:** Native, improved (dialogue, SFX, ambient, music)

Veo 3.1 is an incremental upgrade over Veo 3 with **stronger prompt adherence, richer/more natural audio, and expanded frame controls** — most notably first-frame image-to-video plus (in the rtst API) last-frame interpolation and reference images for character/style consistency.

## rtst usage
```bash
rtst video create veo31 --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `16:9`, `9:16`
- **Resolutions:** `720p`, `1080p`
- **Durations (s):** `4`, `6`, `8`
- **Audio:** Yes — enable with `--audio` (off by default). 3.1's audio sounds more natural and lip-syncs better than 3.0.
- **Image input:** `--first-frame <file>` (start image → video). The rtst veo31 handler also accepts `--last-frame <file>` (animate the motion *between* a start and end frame) and `--reference-image <file>` (repeatable; asset/style anchors for consistent characters and looks). Local files auto-upload; URLs pass through.
- **Person policy:** Same `personGeneration` safety setting as Veo 3 (`allow_all`, `allow_adult`, `dont_allow`); `allow_adult` is Google's documented default. Regional restrictions may still apply to image-to-video.

## What 3.1 improves over 3
- **Prompt adherence:** follows detailed, multi-clause instructions more faithfully.
- **Audiovisual quality:** sharper visuals, smoother motion, and audio that feels real rather than "synthetic."
- **Frame control:** adds **last-frame** interpolation on top of Veo 3's first-frame-only image-to-video, so you can define both ends of a shot and let the model fill the transition (with audio).
- **Consistency:** **reference images** (aka "ingredients to video") keep the same character, prop, or style across shots — great for multi-clip sequences.
- **Note on framing:** sources conflict on which frame feature is "new." Google/community docs describe last-frame + reference images as the 3.1 additions (3.0 already had a start image); the rtst capability sheet phrases it as "adds first-frame." In practice the rtst veo31 handler accepts first-frame, last-frame, and reference-image — use whichever your shot needs.

## How to prompt it
Same discipline as Veo 3 — the **five-part formula** `[Cinematography] + [Subject] + [Action] + [Context] + [Style & Ambiance]` — but 3.1 tolerates and rewards even more structure:

- **Cinematography vocabulary:** *dolly, tracking, crane, aerial, slow pan, POV; wide / medium / close-up / extreme close-up; low angle, two-shot; shallow depth of field, wide-angle, soft focus, macro.*
- **Audio syntax:** dialogue in quotes (`A woman says, "We have to leave now."`), plus `SFX:` and `Ambient:` labels for sound design.
- **Timestamp prompting (a 3.1 strength):** script a multi-shot clip with time ranges, e.g. `[00:00-00:02] wide establishing... [00:02-00:05] reverse close-up, SFX: rustling leaves... [00:05-00:08] crane reveal, swelling score.`
- **Negatives as descriptions:** "an empty street with no cars" rather than "no cars."

## Example prompts
```bash
# First+last frame interpolation with audio
rtst video create veo31 --prompt "Seamless transition: the sealed vault door slowly grinds open as amber light spills across a treasure chamber, dust motes drifting, slow dolly forward. SFX: heavy stone scraping, low resonant hum, Ambient: dripping water." --first-frame ./closed_door.png --last-frame ./open_chamber.png --aspect-ratio 16:9 --duration 8 --resolution 1080p --audio --wait --json
```

```bash
# Reference images for consistent character across a dialogue shot
rtst video create veo31 --prompt "Medium two-shot, the red-haired detective from the reference leans across a diner table and says, \"You lied to me.\" Neon signage flickers through rain-streaked windows, moody film-noir grade, shallow depth of field." --reference-image ./detective.png --reference-image ./diner.png --aspect-ratio 16:9 --duration 6 --resolution 1080p --audio --wait --json
```

```bash
# Pure text-to-video, vertical, timestamped multi-shot
rtst video create veo31 --prompt "[00:00-00:04] Low-angle tracking shot of a surfer paddling out through glassy dawn swells, cinematic backlight. [00:04-00:08] The wave pitches; wide shot as she drops in, spray fanning, SFX: roaring whitewater and gulls." --aspect-ratio 9:16 --duration 8 --resolution 720p --audio --wait --json
```

## Limitations & tips
- **Short clips (4/6/8 s):** keep dialogue and action counts realistic for the runtime.
- **Audio is opt-in** via `--audio`; omit it and the clip is silent.
- **Only 16:9 / 9:16.** No square or ultrawide — use `vidu` for those.
- **First+last frame works best when the two frames are compositionally related;** wildly different framing can produce morphing.
- **Reference-image support** exists in the rtst handler (asset/style types) but is newer and less documented than text-to-video — expect some trial and error for tight identity locks; `vidu` (up to 7 reference images) is the stronger consistency specialist.
- Outputs carry Google's **SynthID** watermark; the same `personGeneration` and real-person restrictions as Veo 3 apply.
- **Unverified:** provider credit cost and exact regional person-generation behavior are not enforced by the rtst client.
