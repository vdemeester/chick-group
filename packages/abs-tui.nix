{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  mpv-unwrapped,
  dbus,
  openssl,
  libsecret,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "abs-tui";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "vdemeester";
    repo = "abs-tui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HEOmLAPfgdqxSO7uYBJkGK1IlcB8yysXvIBsa8BKI2Y=";
  };

  cargoHash = "sha256-2FBWpW71Dwh08vV8HQ7LTfDSKTgqAOsE3KpuhncV4WA=";

  nativeBuildInputs = [
    pkg-config
  ];

  # Use mpv-unwrapped to avoid nixpkgs mpv wrapper breakage
  buildInputs = [
    mpv-unwrapped
    dbus
    openssl
    libsecret
  ];

  meta = {
    description = "Terminal client for Audiobookshelf";
    homepage = "https://github.com/vdemeester/abs-tui";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "abs-tui";
  };
})
