{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  gh,
  fzf,
  jq,
}:

let
  repoMeta = lib.importJSON ../repos/x-main.json;
  fetcher =
    if repoMeta.type == "github" then
      fetchFromGitHub
    else
      throw "Unknown repository type ${repoMeta.type}";
in
buildGoModule (finalAttrs: {
  pname = "gh-pr";
  inherit (repoMeta) version;

  src = fetcher (
    builtins.removeAttrs repoMeta [
      "type"
      "version"
      "vendorHash"
    ]
  );

  vendorHash = repoMeta.vendorHash or (throw "vendorHash missing from ${repoMeta.repo} metadata");

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  subPackages = [ "cmd/gh-pr" ];

  postInstall = ''
    wrapProgram $out/bin/gh-pr \
      --prefix PATH : ${
        lib.makeBinPath [
          gh
          fzf
          jq
        ]
      }

    # Generate shell completions
    installShellCompletion --cmd gh-pr \
      --bash <($out/bin/gh-pr completion bash) \
      --fish <($out/bin/gh-pr completion fish) \
      --zsh <($out/bin/gh-pr completion zsh)
  '';

  meta = {
    description = "GitHub Pull Request management tool";
    homepage = "https://github.com/vdemeester/x";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = finalAttrs.pname;
  };
})
