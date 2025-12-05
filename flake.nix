{
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      pre-commit-hooks,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
          checks = nixpkgs.lib.getAttrs [ "x86_64-linux" "x86_64-darwin" ] self.packages;
        };
        overlays = {
          default = final: prev: import ./overlays final prev;
        };
      };
      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      perSystem =
        { system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowAliases = false;
            overlays = [ self.overlays.default ];
          };
          inherit (pkgs) lib;
          overlayAttrs = builtins.attrNames (import ./overlays pkgs pkgs);

          # Script to check if README.md package table is up to date
          # Note: This uses nix eval so only works outside of nix build sandbox
          check-readme-table = pkgs.writeShellApplication {
            name = "check-readme-table";
            runtimeInputs = with pkgs; [
              jq
              nix
              gawk
              gnugrep
              gnused
              coreutils
            ];
            text = ''
              # Generate current package table using nix eval
              generate_table() {
                echo "| Package | Version | Description |"
                echo "|---------|---------|-------------|"

                nix flake show --json 2>/dev/null | \
                  jq -r '.packages."x86_64-linux" | keys[]' | \
                  sort | \
                  while read -r pkg; do
                    version=$(nix eval ".#''${pkg}.version" --raw 2>/dev/null || echo "unknown")
                    description=$(nix eval ".#''${pkg}.meta.description" --raw 2>/dev/null || echo "")
                    homepage=$(nix eval ".#''${pkg}.meta.homepage" --raw 2>/dev/null || echo "")

                    if [ -n "$homepage" ]; then
                      pkg_link="[''${pkg}](''${homepage})"
                    else
                      pkg_link="''${pkg}"
                    fi

                    echo "| ''${pkg_link} | ''${version} | ''${description} |"
                  done
              }

              # Extract table from README between markers
              extract_readme_table() {
                awk '/<!-- BEGIN PACKAGE TABLE -->/,/<!-- END PACKAGE TABLE -->/' README.md | \
                  grep -v "<!-- BEGIN PACKAGE TABLE -->" | \
                  grep -v "<!-- END PACKAGE TABLE -->" | \
                  sed '/^$/d'
              }

              # Check if README exists (if not, skip silently - we're probably in nix build)
              if [ ! -f "README.md" ]; then
                echo "⊘ README.md not found, skipping check"
                exit 0
              fi

              # Generate current table and extract README table
              CURRENT_TABLE=$(generate_table)
              README_TABLE=$(extract_readme_table)

              # Compare tables
              if [ "$CURRENT_TABLE" != "$README_TABLE" ]; then
                echo "Error: README.md package table is out of date!" >&2
                echo "" >&2
                echo "Please run './generate-package-table' to update it." >&2
                echo "" >&2
                exit 1
              fi

              echo "✓ README.md package table is up to date"
            '';
          };
        in
        {
          packages =
            let
              drvAttrs = builtins.filter (n: lib.isDerivation pkgs.${n}) overlayAttrs;
            in
            lib.listToAttrs (map (n: lib.nameValuePair n pkgs.${n}) drvAttrs);
          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                deadnix.enable = true;
                nixfmt-rfc-style.enable = true;
                # nix-linter.enable = true;
                # statix.enable = true;

                # Custom hook to ensure README package table is up to date
                # Disabled here because it needs nix eval which doesn't work in sandbox
                # The real check happens via .githooks/pre-commit
                check-readme-table = {
                  enable = false;
                  name = "check-readme-table";
                  description = "Check if README.md package table is up to date";
                  entry = "${check-readme-table}/bin/check-readme-table";
                  files = "\\.(nix|md)$";
                  pass_filenames = false;
                };
              };
            };
          };
          devShells.default = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs = with pkgs; [
              pre-commit
            ];
          };
        };
    };

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  inputs.pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nix-github-actions.url = "github:nix-community/nix-github-actions";
  inputs.nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";
}
