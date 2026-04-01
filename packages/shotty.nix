{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "shotty";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "vdemeester";
    repo = "shotty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o+szySeh9SpMsF4AgiHyf+fGTZAvfT42n461vYdvt98=";
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
