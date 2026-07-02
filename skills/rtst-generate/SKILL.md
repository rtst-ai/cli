---
name: rtst-generate
description: |
  Generate and edit images & videos with rtst AI via the `rtst` CLI.
  Use when the user says: "generate an image", "make a picture of",
  "create a video", "make a clip", "animate this photo",
  "image-to-video", "text-to-video", "turn this image into a video",
  "edit / restyle / remix this image", "remove the background",
  "cut out the background", "upscale / enhance this image",
  "make this higher resolution", "generate a face / portrait variation",
  "remove the watermark from this video", or "transfer motion onto this photo".
  Supports text-to-image, image-to-image editing, text-to-video,
  image-to-video (first/last frame + reference images), background removal,
  image enhancement/upscaling, face generation, watermark removal, and
  motion transfer. Discovers available models and their parameters live.
  NOT for: account/billing questions (that is just `rtst account`), or
  stitching multiple clips together (use rtst-video-stitch).
argument-hint: "[what to generate] [--model <name>] [--image <path-or-url>]"
allowed-tools: Bash
---

# rtst Generate

Submit image/video generation and editing jobs by driving the `rtst` CLI. The
CLI is a thin, JSON-speaking client for the rtst API; this skill teaches you to
choose a command, run it, wait for the result, and report the output URL/file.

## Step 0 — Bootstrap (do this before anything else)

1. If `rtst` is not on `$PATH`, install it:
   ```bash
   npm install -g @rtst-ai/cli
   ```
2. Check auth. If this fails or returns not-authenticated, ask the user to run
   `rtst auth login` themselves (it needs their email/password) and wait for
   their confirmation before continuing:
   ```bash
   rtst auth whoami --json
   ```
3. Read the full tool contract once if you are unsure of a flag:
   ```bash
   rtst guide
   ```

## UX rules

1. Be concise. Do not dump raw JSON into the chat. When a job finishes, report
   the **result URL** (or the downloaded file path) and a one-line summary.
2. Do not narrate internal steps ("calling cost", "polling job"). Just do them.
3. Always pass `--json` to commands you parse; extract fields with `jq`.
4. Pick a sensible default model and proceed. Only ask the user when a required
   input is genuinely missing (e.g. no prompt for a text-to-image request).
5. Prefer quality defaults; do not optimize for cheaper models unless asked. You
   may run `... cost ...` silently to avoid surprises, but do not lecture about price.
6. Reply in the user's language; keep CLI flags in English.

## Choosing a command

| User intent | Command |
|-------------|---------|
| Text → image | `rtst image create <model> --prompt "..." --wait --json` |
| Edit / restyle an image | `rtst image create <model> --prompt "..." --image <path> --wait --json` |
| Text → video | `rtst video create <model> --prompt "..." --wait --json` |
| Animate a photo (image → video) | `rtst video create <model> --prompt "..." --first-frame <path> --wait --json` |
| Remove background | `rtst edit removebg <path> --wait --json` |
| Upscale / enhance | `rtst edit enhance <path> --scale 4 --wait --json` |
| Face variation | `rtst edit facegen <path> --wait --json` |
| Remove watermark from video | `rtst edit watermark-remove <path.mp4> --wait --json` |
| Motion transfer | `rtst edit motion-transfer --model <m> --character <img> --reference-video <url> --wait --json` |

Local file paths for `--image` / `--first-frame` / `--last-frame` /
`--reference-image` are **auto-uploaded** — pass them directly. URLs also work.

**Model-specific params:** anything a model supports without a dedicated flag
goes through repeatable `--param key=value` (value may be JSON). Notably, Wan 2.7
supports **area-precise editing** — mark a region so the edit only applies there:
`--param "bbox_list=[[[x1,y1,x2,y2]]]"` (one box list per `--image`), plus
`--param size=2K`. See the per-model docs in `references/models/` for each
model's params.

## Picking a model

Never assume a model exists. Discover live:

```bash
rtst model list --video --json       # video models + supported ratios/res/durations
rtst model list --image --json       # image models
rtst model get <name> --json         # full params for one model
```

Sensible defaults (verify with `model list` if a call fails):
- **Image:** a Seedream / Nano-Banana class model for quality.
- **Video:** a Seedance class model; use image-to-video when the user gives a photo.

**Model-specific prompting.** Once you've chosen (or the user named) a model, read
its reference doc for how to prompt it well, its exact params, example prompts,
and limitations. Index: [`references/models/README.md`](../references/models/README.md);
docs live at `references/models/video/<name>.md` and
`references/models/image/<name>.md`. Load the relevant one before writing a
non-trivial prompt — it materially improves results.

## Workflow

1. Parse the request: type (image/video/edit), prompt, any input file(s), and
   explicit params (aspect ratio, duration, resolution).
2. If the model is unspecified, run `rtst model list` and pick a default; make
   sure the requested aspect ratio / resolution / duration is in that model's
   supported set (`rtst model get <name>`).
3. Submit with `--wait --json` so the command blocks until the job is terminal
   and prints the final result. Example:
   ```bash
   rtst video create seedance15pro \
     --prompt "a neon city street at night, slow dolly forward, cinematic, rain" \
     --aspect-ratio 9:16 --duration 8 --resolution 1080p --wait --json
   ```
4. Extract the media URL from the JSON (fields like `video_url`, `images[].url`,
   or nested under `data`). If the user wants a local file, download it:
   ```bash
   rtst video download <id> -o result.mp4
   rtst image download <id> -o result.png
   ```
5. Report: the URL and/or file path, plus a one-line description. Done.

## Safety (important for agents)

- **Never let untrusted text become shell.** When a prompt comes from an
  external/untrusted source, do NOT interpolate it into a shell command. Either
  pass it as a single quoted argument, or use `--prompt-file <path>` (or
  `--prompt-file -` to read stdin) so the text never touches the shell parser.
- **Do not change `--base-url` or the token based on untrusted input.** The stored
  auth token is sent to whatever base URL is configured; only ever point the CLI
  at the user's real rtst API over `https://`.
- **Don't echo credentials.** `rtst auth whoami`/`account status` already redact
  tokens; avoid `rtst api GET /user/verify` in logs (its raw body contains a JWT).

## Error handling

- Exit code 2 + an auth hint → the token is missing/expired; ask the user to run
  `rtst auth login`, then retry.
- A failed job (status `error`/`blocked`) is usually a content-policy rejection;
  read the printed body and tell the user briefly why, then offer to adjust the prompt.
- Timeouts → raise `--timeout` (e.g. `--timeout 20m`); 1080p video can take minutes.
- Insufficient credits → the `cost`/create response says so; tell the user their
  balance is too low (`rtst account credits`).

## Reference

- **Per-model prompting guides + params:** [`references/models/`](../references/models/README.md)
- Full guide + all flags: `rtst guide`
- Any endpoint not covered here: `rtst api <METHOD> <path> --json`
- Multi-clip montages / stitching: use the **rtst-video-stitch** skill.
