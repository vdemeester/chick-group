#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cacert nodejs git nix-update nix gnused findutils curl jq prefetch-npm-deps

set -euo pipefail

cd "$(dirname "$0")/.."

version=$(npm view @mariozechner/pi-coding-agent version)

echo "Latest version: $version"

# Update version and source hash using nix-update
# Note: nix-update is called without -u/--use-update-script to avoid recursion
nix-update pi-coding-agent --flake --version="$version" --override-filename packages/pi-coding-agent.nix

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
cd -
cp "$TEMP_DIR/package/package-lock.json" packages/package-lock.json

# Calculate and update npmDepsHash
echo "Calculating npmDepsHash..."
new_hash=$(prefetch-npm-deps packages/package-lock.json)
sed -i "s|npmDepsHash = \"sha256-[^\"]*\";|npmDepsHash = \"${new_hash}\";|" packages/pi-coding-agent.nix

echo "✓ Update complete!"
echo "  Version: $version"
echo "  npmDepsHash: $new_hash"
