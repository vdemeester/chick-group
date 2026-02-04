#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cacert nodejs git nix gnused findutils curl jq prefetch-npm-deps

# This script is called AFTER nix-update has updated the version and src hash.
# It only handles what nix-update can't: updating npmDepsHash and package-lock.json.
#
# The script reads the version from the nix file (already updated by nix-update)
# to ensure consistency.

set -euo pipefail

# Save the repo root (current working directory when called)
REPO_ROOT="$(pwd)"

# Read the version from the nix file (already updated by nix-update)
version=$(grep -oP 'version = "\K[^"]+' "$REPO_ROOT/packages/pi-coding-agent.nix")
echo "Current version in nix file: $version"

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
cp "$TEMP_DIR/package/package-lock.json" "$REPO_ROOT/packages/package-lock.json"

# Calculate and update npmDepsHash
echo "Calculating npmDepsHash..."
new_hash=$(prefetch-npm-deps "$REPO_ROOT/packages/package-lock.json")
sed -i "s|npmDepsHash = \"sha256-[^\"]*\";|npmDepsHash = \"${new_hash}\";|" "$REPO_ROOT/packages/pi-coding-agent.nix"

echo "✓ npmDepsHash update complete!"
echo "  Version: $version"
echo "  npmDepsHash: $new_hash"
