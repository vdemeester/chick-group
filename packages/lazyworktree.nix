{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "lazyworktree";
  version = "1.51.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "lazyworktree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KXrbSu7tHFwFAdcxhgn6Sazo+reQ4rVwQ8Kw4mpBcSw=";
  };

  vendorHash = "sha256-z7/75Jnm/MJHWnQK6IgBEQBrc7ugneUEAodfLGOazak=";

  nativeBuildInputs = [ installShellFiles ];

  # Tests require git and are integration tests
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    install -Dm444 shell/functions.{bash,fish,zsh} -t $out/share/lazyworktree
    installManPage lazyworktree.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lazyworktree \
      --bash <($out/bin/lazyworktree completion bash --code) \
      --zsh <($out/bin/lazyworktree completion zsh --code) \
      --fish <($out/bin/lazyworktree completion fish --code)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "BubbleTea-based Terminal User Interface for efficient Git worktree management";
    homepage = "https://github.com/chmouel/lazyworktree";
    changelog = "https://github.com/chmouel/lazyworktree/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "lazyworktree";
  };
})
