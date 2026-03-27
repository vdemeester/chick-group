{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "shotty";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "vdemeester";
    repo = "shotty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HD3QcEvTcwwcmS3PP1X9B1W0vCYWTG6quzYHwNAMjWU=";
  };

  vendorHash = "sha256-n9x5Tkw0lR5N/k9AWt662l1ZnrQZV1UB6OF7vV1C3ZE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Screenshot and recording tool for Wayland";
    homepage = "https://github.com/vdemeester/shotty";
    changelog = "https://github.com/vdemeester/shotty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "shotty";
  };
})
