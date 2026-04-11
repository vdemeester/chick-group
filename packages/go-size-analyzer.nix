{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "go-size-analyzer";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "Zxilly";
    repo = "go-size-analyzer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VRmUlhPOvRed8YEh6LskLZ8f/AIJmRcFMxLtiYDg/Rc=";
  };

  vendorHash = "sha256-Z8PJBflX341OCdZVtaSmVfgb5zRui+oOoSF0rAuajAA=";

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
