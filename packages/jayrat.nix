{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage {
  pname = "jayrat";
  version = "0.5.0";

  src = fetchFromGitLab {
    owner = "chmouel";
    repo = "jayrat";
    rev = "v0.5.0";
    hash = "sha256-PqAUVM4IQonCRtlPB3QaM0BISSQ08eHBSo8T5EIge3E=";
  };

  cargoHash = "sha256-2tEmlzUq0cpD3VRJ+4RmQDVra9BTP20WKlsuN03kMIg=";

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
