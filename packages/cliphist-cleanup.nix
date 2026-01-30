{
  lib,
  buildGoModule,
  fetchFromGitHub,
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
  pname = "cliphist-cleanup";
  inherit (repoMeta) version;

  src = fetcher (
    builtins.removeAttrs repoMeta [
      "type"
      "version"
      "vendorHash"
    ]
  );

  vendorHash = repoMeta.vendorHash or (throw "vendorHash missing from ${repoMeta.repo} metadata");

  subPackages = [ "cmd/cliphist-cleanup" ];

  meta = {
    description = "Clean up cliphist clipboard history by pattern matching";
    homepage = "https://github.com/vdemeester/x";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = finalAttrs.pname;
  };
})
