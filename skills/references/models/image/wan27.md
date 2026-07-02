# Wan 2.7 Image — `wan27`
**Provider:** Alibaba (Tongyi Wanxiang / Wan team) · **Underlying model:** `wan2.7-image-pro` (DashScope) · **Modality:** Image editing / text-to-image ·

Wan 2.7-Image Pro is Alibaba's unified image model (text-to-image + instruction editing + multi-image fusion) with a standout feature: **interactive precise editing** — you can mark rectangular regions of a reference image so the edit only applies inside those boxes. Reach for it when you need a *localized* edit ("change only this area") that leaves the rest of the image untouched, multilingual text rendering, or reference fusion. The API is **synchronous** (results come back in one call; `--wait` is effectively instant).

> Params below are confirmed against the rtst integration (`services/imageModels/wan27.js`), not just vendor docs.

## rtst usage
```bash
rtst image create wan27 --prompt "..." [--image <file>] [--samples N] [--param size=2K] --wait --json
```

## Parameters (enforced by the rtst API)
- **Input images:** `--image <file-or-url>` — repeatable, local files auto-upload. **Up to 6** reference images. One image → edit it; multiple → reference/fusion.
- **`--samples N`** — number of images, **1–4** (values above 4 are clamped to 4).
- **`--param size=<1K|2K|auto>`** — output size tier (default `2K`). This is a Wan-specific body param, so pass it via `--param`, not `--width`/`--height`.
- **Precision / area editing — `--param bbox_list=<json>`** (the headline feature):
  - Format: `List[List[List[int]]]` — the **outer list length must equal the number of `--image` inputs**.
  - Each image contributes a list of **up to 2** bounding boxes; each box is `[x1, y1, x2, y2]` in pixels (top-left → bottom-right) of that image.
  - The model restricts the edit described in `--prompt` to those boxes.
  - Example for **one** image with **one** box: `--param "bbox_list=[[[120,60,480,360]]]"`.
  - Example for one image with **two** boxes: `--param "bbox_list=[[[10,10,200,200],[300,300,500,500]]]"`.
- Watermarking is off and `thinking_mode` is on by default (server-side). No separate mask-image, strength, or negative-prompt flag exists on this route — use `bbox_list` for spatial control.

## How to prompt it
Wan 2.7 editing is **instruction-based**: describe the change and what to preserve.

- **State the edit + the preservation constraint in one sentence.** "Replace the sign text while keeping the wall texture and lighting identical."
- **For localized edits, combine a spatial box with a scoped instruction.** Give `bbox_list` the region and write the prompt as if it only concerns that region: e.g. box around a T-shirt + prompt "change the marked garment to a red hoodie". Everything outside the box stays pixel-stable — this is far more reliable than hoping a global prompt only touches one object.
- **Be specific and localized** even without boxes: name the concrete element ("the red mug on the left", "the sky") rather than a vague global request.
- **Multi-image / reference fusion:** when passing more than one `--image`, say how they relate ("place the product from image 2 into the scene of image 1, matching its lighting"). If you also pass `bbox_list`, remember it needs one entry **per** image (use an empty `[]` for images you don't want boxed).
- **Text rendering:** renders readable, print-grade typography incl. Chinese + English; put the exact string in quotes: `add the caption "GRAND OPENING" in bold serif`.
- **Bilingual:** English or Chinese prompts both work.

## Example prompts
```bash
# 1. Precise area edit — only the marked region changes
rtst image create wan27 \
  --prompt "Inside the marked box, replace the plain white mug with a matte black mug; leave the rest of the photo unchanged" \
  --image ./desk.jpg \
  --param "bbox_list=[[[340,220,560,430]]]" \
  --param size=2K --wait --json
```

```bash
# 2. Text + color edit, 4 variations
rtst image create wan27 \
  --prompt "Add the headline \"SUMMER SALE\" in clean bold sans-serif across the top, and recolor the product to matte forest green" \
  --image ./product.jpg --samples 4 --wait --json
```

```bash
# 3. Multi-image fusion (two inputs)
rtst image create wan27 \
  --prompt "Take the person from image 1 and the sofa from image 2, compose them into a bright modern living room with consistent daylight" \
  --image ./person.jpg --image ./sofa.jpg --wait --json
```

## Limitations & tips
- **`bbox_list` cardinality is strict:** its outer length must match the number of `--image` inputs, and each inner list holds at most 2 boxes. Mismatches are rejected by the provider. Coordinates are pixels in the *input* image's resolution.
- **Size is `1K`/`2K`/`auto` (via `--param size=`), not a pixel `--width`/`--height`.** Default is `2K`.
- **Samples cap at 4.**
- **Editing-first in rtst:** it can do pure text-to-image, but results are best when you supply at least one `--image`.
- **Version churn:** the Wan 2.5/2.6/2.7 line moves fast; if a call behaves unexpectedly, confirm live with `rtst model get wan27 --json` and inspect the response.
- Preserving fine identity/logo detail across large edits can still drift — box the region and state "keep unchanged" explicitly.
