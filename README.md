# @rtst-ai/cli

[![npm version](https://img.shields.io/npm/v/@rtst-ai/cli.svg)](https://www.npmjs.com/package/@rtst-ai/cli)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![node >= 22](https://img.shields.io/badge/node-%3E%3D22-brightgreen.svg)](https://nodejs.org)

The official command-line client for the [rtst](https://rtst.ai) AI image and video generation API.

Generate videos and images from your terminal, your scripts, or your AI agents. Every command supports `--json` for machine-readable output, generation jobs run asynchronously with explicit polling, local files are uploaded automatically, and a generic `rtst api` command covers any endpoint the CLI does not wrap. The CLI is a pure HTTP client and requires no server-side changes.

## Installation

Pick the method that matches your setup. All of them put an `rtst` command on your PATH.

### npm (recommended)

Requires Node.js 22 or later.

```bash
npm install -g @rtst-ai/cli
```

### bun

```bash
bun add -g @rtst-ai/cli
```

### Homebrew (macOS and Linux)

```bash
brew install rtst-ai/tap/rtst
```

### Install script (macOS and Linux, no Node.js required)

Downloads the standalone build for your platform, verifies its checksum, and installs it to `/usr/local`:

```bash
curl -fsSL https://raw.githubusercontent.com/rtst-ai/cli/main/install.sh | sh
```

Options: `sh -s -- --prefix=$HOME/.local` to install without sudo, `sh -s -- --tag v0.1.0` to pin a version.

### Manual download (all platforms, no Node.js required)

Download the archive for your platform from the [releases page](https://github.com/rtst-ai/cli/releases), extract it, and add the `rtst` executable to your PATH. Builds are available for macOS (Intel and Apple Silicon), Linux (x64 and arm64), and Windows (x64 and arm64). Verify downloads against the `checksums.txt` attached to each release.

### Verify the install

```bash
rtst --version
```

## Getting started

Three steps from install to your first generation:

```bash
# 1. Sign in. This opens rtst.ai in your browser (Google, Facebook, and
#    email OTP all work) and stores a token (valid for about 30 days) in
#    your OS keychain on macOS, or in ~/.config/rtst with 0600 permissions.
rtst auth login

# 2. See which models are available and what parameters they accept.
rtst model list --video

# 3. Generate a video, wait for it to finish, and download it.
rtst video create seedance15pro \
  --prompt "a neon city street at night, slow dolly forward, cinematic" \
  --aspect-ratio 9:16 --duration 8 --resolution 1080p --wait

rtst video download <id> -o clip.mp4
```

Tip: preview the credit cost of any generation before running it with `rtst video cost ...` or `rtst image cost ...`, or add `--estimate` to a `create` command to price those exact flags without submitting anything.

## Commands

| Group | Commands | Purpose |
|-------|----------|---------|
| `auth` | `login`, `logout`, `whoami`, `token` | Sign in and out, inspect the stored token |
| `config` | `set`, `list` | Manage the base URL and CLI defaults |
| `model` | `list`, `get` | Discover models and their parameters |
| `video` | `create`, `cost`, `get`, `wait`, `list`, `download` | Generate and retrieve videos |
| `image` | `create`, `cost`, `get`, `wait`, `list`, `download` | Generate and retrieve images |
| `edit` | `removebg`, `enhance`, `facegen`, `watermark-remove`, `motion-transfer` | Image and video editing tools |
| `account` | `status`, `credits`, `statement` | Credits, balance, and transactions |
| top level | `upload`, `api`, `update`, `guide` | File upload, raw API access, self-update, agent guide |

Run `rtst <command> --help` for details on any command, or `rtst guide` for the full automation guide, including ffmpeg recipes.

## Signing in

`rtst auth login` opens the rtst.ai login page in your browser. Sign in with any supported method (Google, Facebook, or email OTP) and click Authorize; the CLI receives the token on a local callback and stores it. Variants:

- `rtst auth login --no-browser` prints the login URL instead of auto-opening a browser.
- `rtst auth login --no-web` uses the terminal email and password flow instead (also triggered by passing `--email` or `--password`). Over SSH, use this: the browser callback only works when the browser runs on the same machine as the CLI.
- Headless, CI, and agent environments should skip login entirely and set `$RTST_TOKEN` (grab one on a trusted machine with `rtst auth token`).

## Global flags

| Flag | Effect |
|------|--------|
| `--json` | Machine-readable output. Recommended for scripts and agents. |
| `--no-color` | Disable ANSI color. |
| `--base-url <url>` | Override the API base URL for this invocation. |
| `--token <jwt>` | Override the stored token for this invocation. |

## Configuration

Settings live under `~/.config/rtst/` (override the location with `$RTST_CONFIG_DIR`):

- `config.json` holds non-secret settings such as the base URL and the credential store choice.
- `credentials.json` holds login metadata. On macOS the token itself is stored in the Keychain, not in this file.

### Credential storage

`rtst auth login` stores the token in the macOS Keychain when available, following the same model as the GitHub CLI. On Linux and Windows, or when the Keychain cannot be used, it falls back to `credentials.json` with `0600` permissions. You can control this behavior:

- `rtst auth login --store auto|keychain|file` sets the store for a single login. An explicit `keychain` fails loudly instead of silently degrading to a file.
- `rtst config set credential-store auto|keychain|file` persists the choice for future logins.
- `$RTST_CREDENTIAL_STORE` overrides both, which is useful for CI and agents that need to force `file`.

Token resolution order: `--token` flag, then `$RTST_TOKEN`, then Keychain, then file. Existing file-based logins keep working, and the token migrates to the Keychain on your next `rtst auth login`. `rtst auth logout` clears both stores. Headless and CI use is unaffected: set `$RTST_TOKEN` as before.

### Environment variables

| Variable | Effect |
|----------|--------|
| `RTST_API_URL` | Override the API base URL. |
| `RTST_TOKEN` | Override the auth token. |
| `RTST_CONFIG_DIR` | Override the config directory. |
| `RTST_CREDENTIAL_STORE` | Force token storage: `auto`, `keychain`, or `file`. |
| `RTST_SKIP_UPDATE_CHECK=1` | Disable the daily update check. |
| `RTST_AUTO_UPDATE=1` | Automatically run `rtst update` when a new version is found (npm installs, interactive terminals only). |
| `RTST_NO_DEVICE_ID=1` | Do not send the pseudonymous device fingerprint header. |

## Updating

The CLI checks the rtst API about once a day and notifies you when a newer version exists. To update:

```bash
rtst update                      # npm installs
brew upgrade rtst                # Homebrew installs
```

Standalone binary users can re-run the install script or download the latest build from the [releases page](https://github.com/rtst-ai/cli/releases).

## Using the CLI with AI agents

The CLI is designed to be driven by LLM agents. Read [AGENTS.md](./AGENTS.md) or run `rtst guide`. The short version:

1. Always pass `--json`, parse stdout, and check the exit code.
2. The flow is `create`, then `wait`, then `download`. Statuses `active` and `success` mean done; `error` and `blocked` mean failed.
3. Preview credit cost with the `cost` subcommands, or `create ... --estimate`, before spending credits.
4. Discover models and valid parameters with `rtst model list` and `rtst model get <name>`. Never assume parameter values.

Ready-made agent skills live in [skills/](./skills/); install them with `npx skills add rtst-ai/cli`.

## Security

See [SECURITY.md](./SECURITY.md) for the threat model, credential handling details, telemetry headers, and how to report a vulnerability. Highlights: the package has no install-time scripts, the self-update package name is hardcoded, and tokens are redacted from `whoami` and `status` output.

## Known limitations

- Validation happens server-side. The CLI does not pre-validate prompt length, sample counts, or per-model parameter enums. Invalid values are rejected by the API and surfaced as structured errors. Discover valid values with `rtst model get <name>`.
- Tokens expire after about 30 days and there is no refresh flow yet. Re-run `rtst auth login` when a call returns a 401.

## About this repository

This repository hosts the documentation, the install script, the agent skills, and the release artifacts for the rtst CLI. The CLI itself is developed in a private repository. Bug reports and feature requests are welcome in the [issue tracker](https://github.com/rtst-ai/cli/issues).

## License

[MIT](./LICENSE)
