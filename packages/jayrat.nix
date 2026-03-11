{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "jayrat";
  version = "0.1.0-unstable-2026-03-11";

  src = fetchFromGitLab {
    owner = "chmouel";
    repo = "jayrat";
    rev = "a982afe7b3ae8b872947a120856beb55a6da22c7";
    hash = "sha256-IbHpKG6wTxaQVIadYAvMPWo0KWriBjc6QSafaiLUgx8=";
  };

  cargoHash = "sha256-HS5aIWRF8R/TNE0187uSRWHKRignwrD5/piYbon6j5k=";

  # Build all workspace members to get both jayrat (TUI) and jrc (CLI)
  cargoBuildFlags = [ "--workspace" ];
  cargoTestFlags = [ "--workspace" ];

  meta = {
    description = "Rust TUI and CLI for Jira";
    homepage = "https://gitlab.com/chmouel/jayrat";
    license = lib.licenses.asl20;
    mainProgram = "jayrat";
  };
}
