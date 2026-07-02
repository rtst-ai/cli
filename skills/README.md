# rtst agent skills

Installable [agent skills](https://skills.sh) that teach your coding agent
(Claude Code, Cursor, Codex, and others) to drive the [`rtst`](../README.md) CLI
for AI image & video generation.

## Install

```bash
# installs the skills below into ~/.claude/skills (or your agent's skill dir)
npx skills add rtst-ai/cli

# then, once:
npm install -g @rtst-ai/cli
rtst auth login
```

After that, just talk to your agent naturally:

> "Generate a 9:16 cinematic video of a neon city street and download it."
>
> "Remove the background from ./photo.png."
>
> "Make a 30-second montage from these three scenes."

## Skills in this repo

| Skill | What it does |
|-------|--------------|
| [`rtst-generate`](./rtst-generate/SKILL.md) | Text/image → image & video, plus edit tools (removebg, enhance, facegen, watermark removal, motion transfer). Discovers models live. |
| [`rtst-video-stitch`](./rtst-video-stitch/SKILL.md) | Generate multiple clips and stitch them with ffmpeg — montages, continuous frame-chained scenes, add audio, GIF previews. |

## How it works

`npx skills add <owner>/<repo>` (the [`skills`](https://github.com/vercel-labs/skills)
CLI) scans this repo's `skills/*/SKILL.md` files and symlinks them into your
agent's skills directory. Each `SKILL.md` is YAML frontmatter (`name`,
`description` with "use when" triggers, `argument-hint`, `allowed-tools`) plus a
markdown body that instructs the agent how to invoke `rtst`.

Every skill's bootstrap step installs the CLI if missing and checks auth before
running any job.

> **Note on `--copy` installs:** the skills link to the shared model reference
> docs in [`references/`](./references/models/README.md) via relative paths.
> With the default **symlink** install those links resolve back into this repo
> and work. With `npx skills add --copy`, only the skill directory is copied, so
> the `references/` links will not resolve — prefer the symlink install, or
> browse the reference docs on the repo.
