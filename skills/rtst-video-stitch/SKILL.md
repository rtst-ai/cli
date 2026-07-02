---
name: rtst-video-stitch
description: |
  Produce multi-shot / montage videos by generating several clips with the
  `rtst` CLI and stitching them with ffmpeg.
  Use when the user says: "make a montage", "create a multi-scene video",
  "generate several clips and join them", "make a 30-second video from these
  scenes", "stitch these together", "concatenate these clips", "chain these
  shots into one continuous video", "storyboard this into a video",
  "add background music to the video", or "make a trailer / ad from these shots".
  Handles: generating N clips (in parallel), concatenating them, chaining shots
  by feeding one clip's last frame as the next clip's first frame for continuity,
  adding an audio track, and exporting a GIF preview.
  Requires ffmpeg on the machine. Depends on rtst-generate for the underlying
  single-clip generation.
argument-hint: "[scene descriptions or a brief] [--duration <s>] [--aspect 9:16]"
allowed-tools: Bash
---

# rtst Video Stitch

Turn a brief or a list of scenes into one finished video: generate each clip via
`rtst`, then assemble with `ffmpeg`.

## Step 0 — Bootstrap

1. Ensure the CLI + auth are ready (see the rtst-generate skill's Step 0):
   ```bash
   rtst auth whoami --json    # if this fails, ask the user to run: rtst auth login
   ```
2. Ensure ffmpeg is installed:
   ```bash
   ffmpeg -version >/dev/null 2>&1 || echo "ffmpeg missing — install it (brew install ffmpeg / apt-get install ffmpeg)"
   ```
3. Work in a scratch directory so intermediate files stay tidy.

## UX rules

- Be concise; report the final file path and duration, not every intermediate step.
- Keep a consistent `--aspect-ratio`, `--resolution`, and `--model` across all
  clips so they concatenate cleanly.
- Pick one model up front via `rtst model list --video --json`.

## Approach A — independent scenes (default)

Best when scenes are distinct. Generate all clips, then concat.

```bash
mkdir -p ./montage && cd ./montage
MODEL=seedance15pro; ASPECT=9:16; DUR=6; RES=1080p

# 1. generate one clip per scene (each --wait blocks; run sequentially or background them)
i=0
for scene in "sunrise over misty mountains, slow pan" \
             "a river winding through a forest, aerial" \
             "waves crashing on rocks at golden hour"; do
  i=$((i+1))
  ID=$(rtst video create "$MODEL" --prompt "$scene, cinematic" \
        --aspect-ratio "$ASPECT" --duration "$DUR" --resolution "$RES" \
        --wait --json | jq -r '.id // .data.id')
  rtst video download "$ID" -o "clip$i.mp4"
done

# 2. concat (same codec/size -> stream copy is fastest)
printf "file '%s'\n" clip*.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy final.mp4
# if clips differ in codec/size, re-encode instead:
# ffmpeg -f concat -safe 0 -i list.txt -vf "scale=1080:1920,fps=30" -c:v libx264 -pix_fmt yuv420p final.mp4
```

## Approach B — continuous scene (frame chaining)

Best when the user wants one flowing shot. Extract the last frame of each clip
and feed it as the next clip's `--first-frame` (use a model that supports
image-to-video).

```bash
PROMPTS=("a car drives down an empty desert highway at dusk" \
         "the same car passes a lone gas station" \
         "the car disappears toward the horizon as night falls")
prev=""
for idx in "${!PROMPTS[@]}"; do
  n=$((idx+1))
  if [ -z "$prev" ]; then
    ID=$(rtst video create "$MODEL" --prompt "${PROMPTS[$idx]}" --aspect-ratio "$ASPECT" --duration "$DUR" --resolution "$RES" --wait --json | jq -r '.id // .data.id')
  else
    ID=$(rtst video create "$MODEL" --prompt "${PROMPTS[$idx]}" --first-frame "$prev" --aspect-ratio "$ASPECT" --duration "$DUR" --resolution "$RES" --wait --json | jq -r '.id // .data.id')
  fi
  rtst video download "$ID" -o "clip$n.mp4"
  # grab the last frame for the next shot
  ffmpeg -y -sseof -0.1 -i "clip$n.mp4" -frames:v 1 -q:v 2 "frame$n.png"
  prev="frame$n.png"
done
printf "file '%s'\n" clip*.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy final.mp4
```

## Finishing touches

Add music (trims to the shorter of the two):
```bash
ffmpeg -i final.mp4 -i music.mp3 -c:v copy -c:a aac -shortest final_with_audio.mp4
```

Make a shareable GIF preview:
```bash
ffmpeg -i final.mp4 -vf "fps=12,scale=480:-1" preview.gif
```

## Workflow summary

1. Bootstrap (CLI, auth, ffmpeg). Pick one model + consistent aspect/res/duration.
2. Turn the brief into an ordered list of scene prompts (ask the user only if the
   brief is empty).
3. Generate clips — Approach A for distinct scenes, Approach B for a continuous shot.
4. Concat with ffmpeg; re-encode if the clips are not uniform.
5. Optionally add audio / export a preview.
6. Report the final file path and total duration.

## Reference

- Per-model prompting + params (pick a video model that fits the look): [`references/models/README.md`](../references/models/README.md)
- Single-clip generation, model discovery, edit tools: the **rtst-generate** skill.
- CLI flags + recipes: `rtst guide`
