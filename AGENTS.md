# rtst CLI — Guide for LLMs & Automation

The `rtst` CLI is a thin, scriptable client for the **rtst** AI image & video
generation API. It is built to be driven by an LLM or a script: every command
supports `--json`, jobs are asynchronous with explicit polling, and local files
are auto-uploaded.

> Print this guide at runtime with `rtst guide` (or `rtst guide --json`).

## Golden rules

1. **Always pass `--json`** and parse **stdout** as JSON. Progress + errors go to
   **stderr**; the JSON result goes to stdout, so `... --json` is safe to pipe.
2. **Check the exit code:** `0` = success, `1` = failure, `2` = usage/auth error.
3. **Generation is async:** `create` returns a job **id**; then `wait` (or poll
   with `get`) until the status is terminal. Terminal **success** =
   `active`/`success`; **failure** = `error`/`blocked`.
4. **Preview spend** before `create`. Credits are real money. Either
   `rtst video|image cost <model> ...`, or add `--estimate` to the exact
   `create` command you are about to run: it prints the cost of those precise
   flags and exits without submitting (no flag-translation mistakes).
5. **Discover** models & their valid params at runtime with `rtst model list` and
   `rtst model get <name>` — never assume a model name or a parameter value.
   In the video table, `i2v` means the model accepts an image input
   (image-to-video via `--first-frame` etc.); `audio` means native audio
   generation. In `--json`, the same facts are `is_image_supported` /
   `is_audio_supported`.

## Install

```bash
npm install -g @rtst-ai/cli
# or grab a standalone binary from the Releases page (no Node required)
```

## Setup / auth

```bash
rtst config set base-url https://api.rtst.ai      # or: rtst config set base-url local
rtst auth login              # opens a BROWSER sign-in (Google/Facebook/OTP) — needs a human
rtst auth whoami --json      # verify
```

`auth login` requires a human to complete the browser flow, so an **agent must
not run it itself** — ask the user to run it in their terminal. (`--no-web
--email ... --password ...` is a terminal fallback; over SSH only that flow
works.) Tokens live ~30 days; the user re-runs `auth login` when they expire.
For **headless / CI / agent** use, skip the login and set environment variables:

```bash
export RTST_API_URL=https://api.rtst.ai
export RTST_TOKEN="$(rtst auth token)"   # capture once, reuse in the environment
```

Resolution precedence for base-url and token: **flag > env
(`RTST_API_URL` / `RTST_TOKEN`) > config file > default**.

## Video lifecycle

```bash
# discover -> estimate -> submit -> wait -> download
rtst model list --video --json
rtst video cost seedance15pro --duration 8 --resolution 1080p --aspect-ratio 9:16 --json

# or estimate with the EXACT create flags (nothing is submitted):
rtst video create seedance15pro --prompt "..." --aspect-ratio 9:16 --duration 8 \
  --resolution 1080p --estimate --json

ID=$(rtst video create seedance15pro \
  --prompt "a neon city street at night, slow dolly forward, cinematic, rain" \
  --aspect-ratio 9:16 --duration 8 --resolution 1080p --json | jq -r '.id // .data.id')

rtst video wait "$ID" --timeout 20m --interval 5s --json
rtst video download "$ID" -o clip.mp4
```

One-shot blocking form: add `--wait` to `create`.

**Image-to-video:** `--first-frame ./start.png` (also `--last-frame`,
`--reference-image` repeatable). Local files auto-upload; URLs pass through.

### Reference images & prompt placeholders (Seedance 2 / Kling 3 / Gemini Omni Flash)

Structured-reference models (`seedance20`, `seedance20fast`, `seedance20mini`,
`kling3`, `kling3omni`, `geminiomniflash`) treat reference images as **named
actors you direct from the prompt**, not as passive style hints. Check support
and limits at runtime: `rtst model get <name> --json` →
`image_capabilities.reference_images` (`supported`, `max`) and
`reference_input_type: "id"` marks a placeholder model.

**How to use:** pass images with the normal flags, then refer to each one
inside the prompt with a placeholder — `{{img1}}` is the first
`--reference-image`, `{{img2}}` the second, ... and `{{first}}`/`{{last}}`
refer to `--first-frame`/`--last-frame`:

```bash
rtst video create seedance20 \
  --reference-image ./hero.png --reference-image ./city.png \
  --prompt "The woman from {{img1}} walks through the neon street from {{img2}}, \
camera tracking her from behind, rain, cinematic atmosphere, slow dolly" \
  --aspect-ratio 16:9 --duration 8 --resolution 1080p --wait --json
```

- The CLI uploads each image as a Photo, and rewrites the placeholders to the
  photo-id tags the API expects; the API then maps them to the provider's
  `[Image N]` labels. Passing a bare number (e.g. `--reference-image 123`)
  reuses an existing photo id directly, and raw `{{123}}` id tags in the
  prompt pass through untouched.
- **Prompt every reference you pass.** A reference image the prompt never
  mentions gives the model nothing to anchor: say what each image contributes
  (person, product, style, background).
- Reference media are content-moderated: photos of public figures are
  rejected, and human photos can take a moment of extra processing on first
  use (retry shortly if told a photo is still processing).
- On all **other** video models, `--reference-image` is unsupported (see
  `image_capabilities`) and image inputs are plain URLs — placeholders have no
  meaning there.

**Video editing (`geminiomniflash`):** pass source footage with
`--reference-video <file|url|id>` and address it in the prompt as `{{vid1}}` —
it can remove objects/people, swap backgrounds, change the color grade,
restyle footage, and add captions while keeping the rest intact:

```bash
rtst video create geminiomniflash --reference-video ./clip.mp4 \
  --prompt "In {{vid1}}, remove the person in the background. Keep everything else the same." \
  --aspect-ratio 16:9 --duration 8 --wait --json
```

Keep edit instructions short and surgical (one change + "Keep everything else
the same"); see `skills/references/models/video/geminiomniflash.md`.

## Image lifecycle

```bash
rtst image cost seedream45 --samples 2 --json    # or: rtst image create ... --estimate --json
rtst image create seedream45 --prompt "studio product shot of a watch on marble, soft light" --samples 2 --wait --json
rtst image download <id> -o out.png
```

img2img / editing: add `--image ./photo.png` (repeatable).

### Model-specific params (`--param`)

Parameters a model supports but that lack a dedicated flag are passed with
repeatable `--param key=value` (value may be JSON):

```bash
# Wan 2.7 precise/area editing — restrict the edit to a marked box + size tier
rtst image create wan27 --image ./photo.png \
  --prompt "inside the marked box, replace the mug with a black one; keep the rest unchanged" \
  --param "bbox_list=[[[340,220,560,430]]]" --param size=2K --wait --json

# Seedance — lock the camera
rtst video create seedance20 --prompt "..." --param camerafixed=true --wait --json
```

Per-model params live in [`skills/references/models/`](./skills/references/models/README.md).

## Edit tools

```bash
rtst edit removebg ./photo.png --wait --json
rtst edit enhance ./photo.png --scale 4 --wait --json
rtst edit facegen ./face.png --style cinematic --wait --json
rtst edit watermark-remove ./clip.mp4 --wait --json
rtst edit motion-transfer --model kling --character ./person.png \
  --reference-video https://example.com/dance.mp4 --orientation image --wait --json
```

Edit tools charge a **fixed per-use price** that cannot be previewed yet (the
API has no estimate endpoint for them — `cost`/`--estimate` do NOT cover
them). Check the balance with `rtst account credits --json` before and after.

Note: **motion transfer** (above — animate a character image using a reference
video's movement) is a different feature from **video-input video models**
(generation models that take a source video; their reference-video length is
priced via `rtst video cost --input-video-duration`). Don't conflate the two.

## Account

```bash
rtst account credits --json
rtst account statement --json
```

## Generic passthrough

Any endpoint not wrapped by a first-class command:

```bash
rtst api GET /rewards --json
rtst api POST /feedback/create --data '{"message":"great app"}' --json
rtst api GET /prompt/community --query page=1 --query limit=10 --json
```

## ffmpeg recipes

The CLI produces media files; use `ffmpeg` for stitching/format work.

**Concatenate clips into one video:**

```bash
printf "file '%s'\n" clip1.mp4 clip2.mp4 clip3.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy final.mp4
# clips with differing codecs/sizes -> re-encode:
# ffmpeg -f concat -safe 0 -i list.txt -vf "scale=1080:1920,fps=30" -c:v libx264 -pix_fmt yuv420p final.mp4
```

**Chain shots** — extract the last frame and feed it as the next `--first-frame`:

```bash
ffmpeg -sseof -0.1 -i clip1.mp4 -frames:v 1 -q:v 2 lastframe.png
rtst video create seedance15pro --prompt "continue the scene..." --first-frame lastframe.png --wait --json
```

**Add audio / make a GIF preview:**

```bash
ffmpeg -i final.mp4 -i music.mp3 -c:v copy -c:a aac -shortest final_with_audio.mp4
ffmpeg -i clip.mp4 -vf "fps=12,scale=480:-1" preview.gif
```

## Error handling for agents

- With `--json`, errors print `{"success":false,"error":"...","status":N,"hint":"...","body":...}`
  to stdout. **The `hint` field tells you the next command to run — follow it.**
- **Exit 2 (auth)** → the token is missing or expired. Ask the user to run
  `rtst auth login` (browser sign-in), or set a fresh `RTST_TOKEN`, then retry
  the same command.
- **HTTP 402 / credit errors** → check `rtst account credits --json`; the user
  tops up at https://rtst.ai.
- **HTTP 400/422** → invalid params: re-check `rtst model get <name> --json`.
- **HTTP 404** → wrong model name or job id: `rtst model list --json`,
  `rtst video list --json` / `rtst image list --json`.
- **HTTP 429 / 5xx** → transient: back off and retry.
- A **failed job** (status `error`/`blocked`) makes `wait` exit non-zero; read the
  printed body for the provider's reason (often a content-policy rejection —
  rephrase the prompt and resubmit).
- **Timeouts:** raise `--timeout`; 1080p video jobs can take several minutes.

## Safety

- Pass untrusted/long prompt text with `--prompt-file <path>` (or `--prompt-file -`
  for stdin) instead of interpolating it into a shell command.
- The stored token is sent to whatever base URL is configured — never set
  `--base-url`/`$RTST_API_URL` from untrusted input; use `https://` only.
- `auth whoami`/`account status` redact tokens; don't log raw `rtst api GET /user/verify`.
