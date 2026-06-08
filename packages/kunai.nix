{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kunai";
  version = "0.1.0-unstable-2025-06-07";

  src = fetchFromGitHub {
    owner = "mikkurogue";
    repo = "kunai";
    rev = "494af5aabc9905a52a8cdbcdff2abe8d0184ef1a";
    hash = "sha256-n3diNIAtEUhCkSshfALjme0epl90QJmIAyumt8Qx8Tc=";
  };

  cargoHash = "sha256-YPTh0SJTvIZFyF1ruNE1OPuP1oFmrjlsY+ChGwozvVM=";

  meta = {
    description = "Per-keyboard layout switcher for Niri compositor";
    homepage = "https://github.com/mikkurogue/kunai";
    license = lib.licenses.free;
    mainProgram = "kunai";
    platforms = lib.platforms.linux;
  };
})
