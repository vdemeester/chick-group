{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage {
  pname = "jayrat";
  version = "0.1.0-unstable-2026-03-31";

  src = fetchFromGitLab {
    owner = "chmouel";
    repo = "jayrat";
    rev = "9a242b291e3e4113ff501d6b7e29e383fc48533d";
    hash = "sha256-1tCVzHtJDoePCctEN9CYtPIEyUyGL/bgfCyxxgfvOso=";
  };

  cargoHash = "sha256-AXu6zBiZc2VlFYlg+fNLQ1ktgeq2MQPtYXXRxHWteCA=";

  nativeBuildInputs = [ installShellFiles ];

  # Build all workspace members to get both jayrat (TUI) and jrc (CLI)
  cargoBuildFlags = [ "--workspace" ];
  cargoTestFlags = [ "--workspace" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd jayrat \
      --bash <($out/bin/jayrat completions bash) \
      --zsh <($out/bin/jayrat completions zsh) \
      --fish <($out/bin/jayrat completions fish)
    installShellCompletion --cmd jrc \
      --bash <($out/bin/jrc completions bash) \
      --zsh <($out/bin/jrc completions zsh) \
      --fish <($out/bin/jrc completions fish)
  '';

  meta = {
    description = "Rust TUI and CLI for Jira";
    homepage = "https://gitlab.com/chmouel/jayrat";
    license = lib.licenses.asl20;
    mainProgram = "jayrat";
  };
}
