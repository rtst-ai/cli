# Security

## Reporting a vulnerability

Please report security issues privately to **security@rtst.ai** (do not open a
public issue). We aim to acknowledge within 3 business days.

## Threat model

`rtst` is a local command-line HTTP client for the rtst API. It:

- stores an auth JWT on the local machine and attaches it to API requests;
- reads local files the user points at (images) and uploads them to the API;
- downloads result media from URLs the API returns;
- offers `rtst api` (raw request) and `--param` (arbitrary body fields) escape hatches.

It runs with the invoking user's privileges on their own machine. There is no
multi-tenant/privilege boundary inside the CLI; the primary assets to protect are
**the auth token** and **the integrity of what the agent/user is convinced to run**.

## Hardening in place

- **Credential storage.** On macOS the token is stored in the **login Keychain**
  (via `/usr/bin/security`, the same mechanism the GitHub CLI uses): encrypted at
  rest, locked outside the session, and never present in dotfiles — so it can't
  leak through dotfile backups, cloud sync, or a stray `grep -r ~`. The secret is
  written via stdin (never argv, so it can't appear in `ps`). Elsewhere — and as
  an explicit or automatic fallback — the token goes to
  `~/.config/rtst/credentials.json` with `chmod 600` (dir `0700`); on Windows
  POSIX perms don't apply (documented). `rtst auth logout` clears both stores.
  Honest scope: the Keychain item's ACL trusts Apple's `security` tool, so **any
  process running as the same user can still read it** — like the 0600 file,
  this protects at rest, not against same-user malware. A locked keychain or SSH
  session falls back to file/env with a warning (never a silent unauthenticated
  run).
- **No token logging / echo.** The token is never written to logs. `config list`
  shows only a boolean. `auth whoami` and `account status` call `/user/verify`
  (which mints a fresh JWT in its body) and **redact** the token before printing,
  so `--json` output is safe to pipe/log. Use `rtst auth token` to print a token on purpose.
- **Cleartext-transport warning.** If the token would be sent over plain `http://`
  to a non-loopback host, the CLI prints a one-time stderr warning.
- **No shell execution.** The CLI never invokes a shell or `eval`; requests use
  `fetch`, and downloads only fetch `http(s)` URLs. The only `child_process`
  uses are two fixed, non-user-controlled invocations: npm self-update
  (`rtst update`) and the macOS Keychain tool — both spawned with argument
  arrays; the Keychain tool additionally by absolute path (`/usr/bin/security`)
  to rule out `$PATH` hijacking.
- **No install scripts.** The package has no `pre/postinstall` lifecycle scripts,
  so `npm i -g @rtst-ai/cli` does not execute arbitrary code at install time.
- **Injection-resistant inputs.** `--param`/`--query` reject `__proto__`,
  `constructor`, `prototype` and use null-prototype accumulators (no prototype
  pollution). `--data` is parsed with `JSON.parse` (no `eval`).
- **Prompt without shell exposure.** `--prompt-file <path>` (or `-` for stdin)
  lets automation pass long/untrusted prompt text without shell-quoting hazards.

## Residual risks & guidance

- **Token exfiltration via base URL.** The stored token is attached to whatever
  base URL is configured. Never set `--base-url` / `$RTST_API_URL` /
  `config set base-url` from untrusted input; only point at the real API over
  `https://`. (Cross-origin redirects strip `Authorization` per the fetch spec.)
- **`--token` on the command line** is visible in the process list and shell
  history. Prefer `rtst auth login` (stored, 0600) or `$RTST_TOKEN`.
- **`rtst api` is an unrestricted escape hatch** — it sends the token with any
  method/path and does NOT redact response bodies. Don't log the raw output of
  endpoints that echo credentials (e.g. `/user/verify`).
- **Agent command-injection.** When an LLM drives the CLI (see `skills/`), a
  prompt built from untrusted text and interpolated unquoted into a shell is the
  main risk. Use `--prompt-file`/stdin or a single quoted argument; the skills
  document this.
- **Token lifetime.** JWTs last ~30 days with no server-side revocation from the
  CLI; `rtst auth logout` only removes the local copy.

## Telemetry, headers & update checks

Every API request carries identifying headers so the backend can attribute CLI
traffic (matching the app's `deviceFingerprint` convention): `User-Agent`,
`X-Platform` (OS), `X-Tool: cli`, `X-App-Version` (the app API surface the CLI
targets — the backend semver-gates model catalogs on it), `X-CLI-Version` (the
CLI's own version), and `X-Device-Fingerprint`.

- **`X-Device-Fingerprint`** is a one-way SHA-256 of stable machine attributes
  (hostname, OS, arch, username, first MAC) — pseudonymous, never the raw values,
  persisted to `config.json`. Opt out with **`RTST_NO_DEVICE_ID=1`**.
- **Update checks** call `GET /config/app-version?platform=cli` (public, no token),
  cached ~daily, bounded by a 2s timeout, fail-silent. Opt out with
  **`RTST_SKIP_UPDATE_CHECK=1`**.
- **Self-update** (`rtst update`, or auto when **`RTST_AUTO_UPDATE=1`**) runs
  `npm i -g @rtst-ai/cli@latest`. The package name is **hardcoded** and never taken
  from the API response — a compromised server can only signal "an update exists,"
  not cause an arbitrary package to install. npm is spawned with an argument array
  (no shell). Auto-update is off by default and requires an interactive TTY.

## Dependencies

- **Runtime deps** (`@oclif/core`, `@oclif/plugin-help`): `npm audit --omit=dev`
  reports **0 vulnerabilities**.
- **Dev-only deps** (vitest → vite/esbuild) carry advisories that do not ship in
  the published package and don't affect a CLI (they concern a vite dev server).
  Tracked for a `vitest` v4 bump.
- Publish from CI with an npm automation token (2FA-backed). Provenance
  attestation is planned if the source repository becomes public (npm
  provenance requires a public repo to be verifiable).
