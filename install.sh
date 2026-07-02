#!/bin/sh
# rtst CLI installer for macOS and Linux.
#
# Downloads the standalone build (Node.js bundled, no runtime dependency),
# verifies its checksum, and installs it under a prefix.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/rtst-ai/cli/main/install.sh | sh
#   curl -fsSL ... | sh -s -- --prefix=$HOME/.local   # install without sudo
#   curl -fsSL ... | sh -s -- --tag v0.1.0            # pin a version
#
# Windows: download the win32 archive from
# https://github.com/rtst-ai/cli/releases and add rtst\bin to your PATH.

set -eu

REPO="rtst-ai/cli"
PREFIX="/usr/local"
TAG=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --prefix=*) PREFIX="${1#*=}"; shift ;;
    --prefix)   PREFIX="$2"; shift 2 ;;
    --tag=*)    TAG="${1#*=}"; shift ;;
    --tag)      TAG="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

OS="$(uname -s)"
case "$OS" in
  Darwin) OS="darwin" ;;
  Linux)  OS="linux" ;;
  *) echo "Unsupported OS: $OS. Download a build from https://github.com/${REPO}/releases" >&2; exit 1 ;;
esac

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64)  ARCH="x64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

if [ -z "$TAG" ]; then
  # The /releases/latest URL redirects to /releases/tag/<tag>.
  TAG="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/${REPO}/releases/latest")"
  TAG="${TAG##*/}"
fi
if [ -z "$TAG" ] || [ "$TAG" = "releases" ]; then
  echo "Could not resolve the latest release tag. Pass one with --tag vX.Y.Z" >&2
  exit 1
fi
VERSION="${TAG#v}"

ASSET="rtst-${VERSION}-${OS}-${ARCH}.tar.gz"
BASE_URL="https://github.com/${REPO}/releases/download/${TAG}"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading ${ASSET} (${TAG})..."
curl -fsSL -o "${TMP}/${ASSET}" "${BASE_URL}/${ASSET}"
curl -fsSL -o "${TMP}/checksums.txt" "${BASE_URL}/checksums.txt"

echo "Verifying checksum..."
EXPECTED="$(grep " ${ASSET}\$" "${TMP}/checksums.txt" | cut -d' ' -f1)"
if [ -z "$EXPECTED" ]; then
  echo "No checksum entry for ${ASSET} in checksums.txt" >&2
  exit 1
fi
if command -v sha256sum >/dev/null 2>&1; then
  ACTUAL="$(sha256sum "${TMP}/${ASSET}" | cut -d' ' -f1)"
else
  ACTUAL="$(shasum -a 256 "${TMP}/${ASSET}" | cut -d' ' -f1)"
fi
if [ "$EXPECTED" != "$ACTUAL" ]; then
  echo "Checksum mismatch for ${ASSET}: expected ${EXPECTED}, got ${ACTUAL}" >&2
  exit 1
fi

LIB_DIR="${PREFIX}/lib"
BIN_DIR="${PREFIX}/bin"
if [ ! -w "$PREFIX" ] && [ "$(id -u)" != "0" ]; then
  echo "${PREFIX} is not writable. Re-run with sudo, or install to your home directory:" >&2
  echo "  curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | sh -s -- --prefix=\$HOME/.local" >&2
  exit 1
fi

echo "Installing to ${LIB_DIR}/rtst..."
mkdir -p "$LIB_DIR" "$BIN_DIR"
tar -xzf "${TMP}/${ASSET}" -C "$TMP"
rm -rf "${LIB_DIR}/rtst"
mv "${TMP}/rtst" "${LIB_DIR}/rtst"
ln -sf "${LIB_DIR}/rtst/bin/rtst" "${BIN_DIR}/rtst"

echo "Installed: $("${BIN_DIR}/rtst" --version)"
case ":$PATH:" in
  *":${BIN_DIR}:"*) ;;
  *) echo "Note: ${BIN_DIR} is not on your PATH. Add it to your shell profile." ;;
esac
echo "Get started:  rtst auth login"
