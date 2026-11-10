{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  pkg-config,
  gtk4,
  libadwaita,
  gobject-introspection,
}:

buildGo126Module (finalAttrs: {
  pname = "tequilashot";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "tequilashot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HgaRpVooGI6RkVCEcUcO3/ivvnsvl8WjdWz6vnMDQv4=";
  };

  vendorHash = "sha256-NtYaTLcVRFT4mbzmeaO0YHJW9cy9YSkGrAt6ocWuFok=";

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  subPackages = [ "cmd/tequilashot" ];

  # Nixpkgs provides Go 1.26; upstream requires the currently unavailable 1.25.6.
  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.25.6" "go 1.25"
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "GPU-accelerated screenshots and screen recording for Sway and Hyprland";
    homepage = "https://github.com/chmouel/tequilashot";
    changelog = "https://github.com/chmouel/tequilashot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "tequilashot";
  };
})
