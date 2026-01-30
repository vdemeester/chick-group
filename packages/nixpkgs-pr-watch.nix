{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gh,
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
  pname = "nixpkgs-pr-watch";
  inherit (repoMeta) version;

  src = fetcher (
    builtins.removeAttrs repoMeta [
      "type"
      "version"
      "vendorHash"
    ]
  );

  vendorHash = repoMeta.vendorHash or (throw "vendorHash missing from ${repoMeta.repo} metadata");

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [ "cmd/nixpkgs-pr-watch" ];

  postInstall = ''
    wrapProgram $out/bin/nixpkgs-pr-watch \
      --prefix PATH : ${lib.makeBinPath [ gh ]}
  '';

  meta = {
    description = "Watch nixpkgs PRs affecting your system packages";
    homepage = "https://github.com/vdemeester/x";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = finalAttrs.pname;
  };
})
