# Wan 2.5 — `wan25`
**Provider:** Alibaba (Tongyi Wanxiang) · **Underlying model:** Wan 2.5 (hosted, DashScope preview lineage) · **Modality:** Text-to-video + image-to-video (first frame) · **Audio:** Native, synchronized (dialogue, SFX, music)

Wan 2.5 is the first Wan tier with native audio: it generates video and synchronized sound — dialogue with lip-sync, ambient effects, and background music — in a single pass. Use it for cinematic clips up to 10 seconds where sound matters and you want flexible durations.

## rtst usage
```bash
rtst video create wan25 --prompt "..." [flags] --wait --json
```

## Parameters (enforced by the rtst API)
- **Aspect ratios:** `16:9`, `9:16`
- **Resolutions:** `480p`, `720p`, `1080p`
- **Durations (s):** `4`, `5`, `6`, `7`, `8`, `9`, `10`
- **Audio:** Supported — pass `--audio` to generate synchronized sound
- **Image input:** `--first-frame <file>` for image-to-video (local files auto-upload). `--last-frame` / `--reference-image` are general rtst flags; per-model support on wan25 is unverified.

## How to prompt it
Since this tier is audio-native, use the extended formula: **Entity + Scene + Motion + Sound description (voice / sound effect / background music)**. All the visual rules from the open Wan lineage still apply — prompting carries over from Wan2.1/2.2.

- **Visual layers:** Subject → Motion → Camera → Scene/Lighting; front-load the subject (Wan weights the start of the prompt).
- **Subject:** 2+ distinguishing features; **Motion:** Speed + Direction + Body mechanics; **Camera:** one shot type (push-in, pull-out, tracking, orbit, fixed); **Scene:** concrete environment + lighting (soft/hard/rim/side light, daylight/dusk/night).
- **Audio — dialogue:** don't just ask for "dialogue". Give the exact words and who says them, plus **emotion + tone + speed + timbre + accent**. e.g. *He says "We shouldn't be here" in a low, nervous whisper, slightly fast, American English.*
- **Audio — SFX:** describe source + action + ambient ("footsteps crunching on gravel, distant wind").
- **Audio — music:** style + role ("tense low strings building under the scene").
- **Bilingual:** English and Chinese both supported; lip-sync works in both.
- **prompt_extend:** brief prompts are auto-expanded into structured descriptions — keep the core intent explicit.
- **Length:** ~40–120 words works well once audio is layered in.

## Example prompts
```bash
rtst video create wan25 --prompt "A chef in a busy kitchen plates a dish and looks up at the camera, warm side light, slow push-in; he says \"Order up, table six!\" in a confident cheerful tone with an American accent; sizzling pans and clattering plates in the background" --aspect-ratio 16:9 --duration 8 --resolution 1080p --audio --wait --json
```

```bash
rtst video create wan25 --prompt "A lone hiker crests a snowy ridge at dawn, wind whipping her jacket, wide shot slowly pushing in, cold blue light warming to gold; howling wind and crunching snow underfoot, soft ambient strings swelling as the sun rises" --aspect-ratio 9:16 --duration 10 --resolution 720p --audio --wait --json
```

```bash
# Image-to-video from a first frame, with synced sound
rtst video create wan25 --prompt "Bring this portrait to life: she smiles and says \"It's good to see you again\" in a warm gentle voice, soft speed, subtle head tilt, shallow depth of field; quiet cafe ambience with faint background chatter" --first-frame ./portrait.jpg --aspect-ratio 16:9 --duration 5 --resolution 720p --audio --wait --json
```

## Limitations & tips
- **Only two aspect ratios** on this tier: `16:9` and `9:16` (no `1:1`/`3:4`/`4:3`). Choose orientation up front.
- **Max 10s.** Longer narratives should be split across clips; avoid cramming multiple scene changes into one prompt.
- Lip-sync to exact words is strongest with short, clearly quoted lines; very long monologues drift.
- Wan 2.5 originated as a DashScope preview and the 2.5/2.6/2.7 line is fast-moving with overlapping public naming — some capabilities are hard to verify and the backend build may change. Validate with a cheap 480p pass before committing to 1080p + audio.
