#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cacert nodejs git nix gnused findutils curl jq prefetch-npm-deps

# This script is called by nix-update via passthru.updateScript.
# nix-update handles version and source hash updates automatically.
# This script only handles what nix-update can't: updating npmDepsHash.

set -euo pipefail

cd "$(dirname "$0")/.."

# Get the latest version from npm
version=$(npm view @mariozechner/pi-coding-agent version)
echo "Latest version: $version"

# Download the new package-lock.json from npm
echo "Downloading package-lock.json for version $version..."
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

cd "$TEMP_DIR"
curl -fsSL "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-${version}.tgz" | tar xz
cd package

# Generate package-lock.json if it doesn't exist
if [ ! -f package-lock.json ]; then
  echo "Generating package-lock.json..."
  npm install --package-lock-only
fi

# Copy the new package-lock.json back to the repo
cd - > /dev/null
cp "$TEMP_DIR/package/package-lock.json" packages/package-lock.json

# Calculate and update npmDepsHash
echo "Calculating npmDepsHash..."
new_hash=$(prefetch-npm-deps packages/package-lock.json)
sed -i "s|npmDepsHash = \"sha256-[^\"]*\";|npmDepsHash = \"${new_hash}\";|" packages/pi-coding-agent.nix

echo "✓ Update complete!"
echo "  Version: $version"
echo "  npmDepsHash: $new_hash"
