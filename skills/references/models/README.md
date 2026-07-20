# rtst model reference

Per-model guides for driving the `rtst` CLI: what each model is, its exact
parameters, **how to prompt it well**, example prompts, and limitations. The
`rtst-generate` and `rtst-video-stitch` skills point agents here when a request
names (or would benefit from) a specific model.

> Parameters listed here are the ground truth the API enforces. You can always
> re-check live with `rtst model get <name> --json`.

## Video models

`i2v` = accepts an image input (image-to-video, e.g. `--first-frame`; "first+last"
means `--last-frame` works too). `audio` = native audio generation.

Structured-reference models (`seedance20`/`fast`/`mini`, `kling3`, `kling3omni`,
`geminiomniflash`) take image inputs as photo ids and want each reference
mentioned in the prompt via placeholders (`{{img1}}`, `{{img2}}`, ...,
`{{first}}`/`{{last}}`) — the CLI handles the upload/rewrite; see each model's
doc and `rtst model get <name> --json` → `image_capabilities`.

| `rtst` model | Underlying model | i2v | audio | doc |
|--------------|------------------|-----|-------|-----|
| `seedance15pro` | ByteDance Seedance 1.5 Pro | ✓ (first+last) | ✓ | [video/seedance15pro.md](./video/seedance15pro.md) |
| `seedance20` | ByteDance Seedance 2.0 | ✓ (first+last) | ✓ | [video/seedance20.md](./video/seedance20.md) |
| `seedance20fast` | ByteDance Seedance 2.0 Fast | ✓ | ✓ | [video/seedance20fast.md](./video/seedance20fast.md) |
| `seedance20mini` | ByteDance Seedance 2.0 Mini | ✓ | ✓ | [video/seedance20mini.md](./video/seedance20mini.md) |
| `kling3` | Kuaishou Kling 3.0 | ✓ (first+last) | ✓ | [video/kling3.md](./video/kling3.md) |
| `kling3omni` | Kuaishou Kling 3 Omni | ✓ (first+last) | ✓ | [video/kling3omni.md](./video/kling3omni.md) |
| `kling26` | Kuaishou Kling 2.6 | ✓ (first+last) | ✓ | [video/kling26.md](./video/kling26.md) |
| `geminiomniflash` | Google Gemini Omni Flash | ✓ (first+last) | ✓ (native, no flag) | [video/geminiomniflash.md](./video/geminiomniflash.md) |
| `ltx23` | Lightricks LTX-2 Pro | ✓ | ✓ | [video/ltx23.md](./video/ltx23.md) |
| `veo3` | Google Veo 3 | ✓ | ✓ | [video/veo3.md](./video/veo3.md) |
| `veo31` | Google Veo 3.1 | ✓ (first frame) | ✓ | [video/veo31.md](./video/veo31.md) |
| `hailuo23` | MiniMax Hailuo 2.3 | ✓ | ✓ | [video/hailuo23.md](./video/hailuo23.md) |
| `vidu` | Vidu Q2 | ✓ (first+last) | ✓ | [video/vidu.md](./video/vidu.md) |
| `wan22` | Alibaba Wan 2.2 | ✓ | ✗ | [video/wan22.md](./video/wan22.md) |
| `wan25` | Alibaba Wan 2.5 | ✓ | ✓ | [video/wan25.md](./video/wan25.md) |
| `wan26` | Alibaba Wan 2.6 | ✓ | ✓ | [video/wan26.md](./video/wan26.md) |
| `wan26flash` | Alibaba Wan 2.6 Flash | ✗ | ✓ | [video/wan26flash.md](./video/wan26flash.md) |

## Image models

| `rtst` model | Underlying model | type | doc |
|--------------|------------------|------|-----|
| `nanobananapro` | Google Nano Banana Pro (Gemini 3 Pro Image) | img2img | [image/nanobananapro.md](./image/nanobananapro.md) |
| `nanobanana2` | Google Nano Banana 2 | img2img | [image/nanobanana2.md](./image/nanobanana2.md) |
| `nanobanana` | Google Nano Banana (Gemini 2.5 Flash Image) | img2img | [image/nanobanana.md](./image/nanobanana.md) |
| `seedream45` | ByteDance Seedream 4.5 | img2img | [image/seedream45.md](./image/seedream45.md) |
| `seedream50-lite` | ByteDance Seedream 5.0 | img2img | [image/seedream50-lite.md](./image/seedream50-lite.md) |
| `seedream40` | ByteDance Seedream 4.0 | img2img | [image/seedream40.md](./image/seedream40.md) |
| `qwen-image-2.0-pro` | Alibaba Qwen-Image 2.0 Pro | img2img | [image/qwen-image-2.0-pro.md](./image/qwen-image-2.0-pro.md) |
| `qwen-image` | Alibaba Qwen-Image Edit | img2img | [image/qwen-image.md](./image/qwen-image.md) |
| `gpt15` | OpenAI GPT Image (gpt-image-1) | img2img | [image/gpt15.md](./image/gpt15.md) |
| `gpt20` | OpenAI GPT Image 2 | img2img | [image/gpt20.md](./image/gpt20.md) |
| `flux-2` / `flux-2-image` | Black Forest Labs FLUX.2 | txt2img / img2img | [image/flux-2.md](./image/flux-2.md) |
| `grok` | xAI Grok Image | img2img | [image/grok.md](./image/grok.md) |
| `reve` | Reve image edit | img2img | [image/reve.md](./image/reve.md) |
| `z-image-turbo` | Tongyi Z-Image Turbo | txt2img | [image/z-image-turbo.md](./image/z-image-turbo.md) |
| `wan27` | Alibaba Wan 2.7 image | img2img | [image/wan27.md](./image/wan27.md) |
| `vidu` (image) | Vidu image | img2img | [image/vidu-image.md](./image/vidu-image.md) |

See [TEMPLATE.md](./TEMPLATE.md) for the doc structure.
