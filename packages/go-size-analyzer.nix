{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "go-size-analyzer";
  version = "1.12.6";

  src = fetchFromGitHub {
    owner = "Zxilly";
    repo = "go-size-analyzer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+lBsikXZCwx6QVEG7dKlpekfQAgHkG+9JN8E/DiS1l8=";
  };

  vendorHash = "sha256-ZjDe4etqi90U+7L+jYAaa0RV/D86Gz7NbLU+eSxcPnI=";

  subPackages = [ "cmd/gsa" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Zxilly/go-size-analyzer.version=${finalAttrs.version}"
  ];

  # Tests require network access and additional tooling
  doCheck = false;

  meta = {
    description = "A tool for analyzing the size of compiled Go binaries, offering cross-platform support, detailed breakdowns, and multiple output formats";
    homepage = "https://github.com/Zxilly/go-size-analyzer";
    changelog = "https://github.com/Zxilly/go-size-analyzer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "gsa";
  };
})
