{
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        overlays = {
          default = final: prev: import ./overlays final prev;
        };
      };
      systems = [ "aarch64-linux" "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
      perSystem = { system, config, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowAliases = false;
            overlays = [ self.overlays.default ];
          };
          inherit (pkgs) lib;
          overlayAttrs = builtins.attrNames (import ./overlays pkgs pkgs);
        in
        {
          packages =
            let
              drvAttrs = builtins.filter (n: lib.isDerivation pkgs.${n}) overlayAttrs;
            in
            lib.listToAttrs (map (n: lib.nameValuePair n pkgs.${n}) drvAttrs);
        };
    };
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
}
