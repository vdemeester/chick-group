# chick-group

🐤 Collection of Nix packages maintained by [@vdemeester](https://github.com/vdemeester)

## Packages

This repository provides the following packages:

### startpaac

**Version:** 20251112.0
**Source:** [chmouel/startpaac](https://github.com/chmouel/startpaac)
**Description:** StartPAAC - All in one setup for Pipelines as Code on Kind

A tool that sets up a complete Pipelines as Code environment on a local Kind (Kubernetes in Docker) cluster.

### kss

**Version:** 0.4.0
**Source:** [chmouel/kss](https://github.com/chmouel/kss)
**Description:** Kubernetes Secret Switcher

A utility for managing and switching between Kubernetes secrets, with Zsh completion support.

### deptree

**Version:** 20251114.0
**Source:** [vc60er/deptree](https://github.com/vc60er/deptree)
**Description:** Dependency tree visualization tool

A Go-based tool for visualizing and analyzing dependency trees.

## Installation

### Using Nix Flakes

You can use these packages directly with Nix flakes:

```bash
# Try a package without installing
nix run github:vdemeester/chick-group#startpaac
nix run github:vdemeester/chick-group#kss
nix run github:vdemeester/chick-group#deptree

# Install a package to your profile
nix profile install github:vdemeester/chick-group#startpaac
```

### Using the Overlay

Add the overlay to your NixOS configuration or home-manager:

```nix
{
  inputs.chick-group.url = "github:vdemeester/chick-group";

  # In your nixpkgs config:
  nixpkgs.overlays = [ inputs.chick-group.overlays.default ];

  # Then use the packages:
  environment.systemPackages = with pkgs; [
    startpaac
    kss
    deptree
  ];
}
```

## Supported Systems

- `x86_64-linux`
- `x86_64-darwin`
- `aarch64-linux`
- `aarch64-darwin`

## Development

This repository uses [flake-parts](https://github.com/hercules-ci/flake-parts) for organization and includes pre-commit hooks for code quality.

### Setup Development Environment

```bash
# Enter the development shell
nix develop

# Pre-commit hooks will be automatically installed
```

### Updating Package Versions

Package versions are tracked in the `repos/` directory:

```bash
# Run the update script to fetch latest versions
./update
```

### Building Packages Locally

```bash
# Build a specific package
nix build .#startpaac
nix build .#kss
nix build .#deptree

# Build all packages
nix build .#
```

## CI/CD

This repository uses GitHub Actions for continuous integration. All packages are automatically built and tested across supported platforms.

## License

This repository is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Maintainer

[@vdemeester](https://github.com/vdemeester)
