{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "shotty";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vdemeester";
    repo = "shotty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KADEfnmYD8Yf2d5yNaz+ULmmpgwLkmdbM//HQt97BPQ=";
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
