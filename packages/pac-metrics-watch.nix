{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  repoMeta = lib.importJSON ../repos/pac-metrics-watch-main.json;
  fetcher =
    if repoMeta.type == "github" then
      fetchFromGitHub
    else
      throw "Unknown repository type ${repoMeta.type}";
in
buildGoModule (finalAttrs: {
  pname = "pac-metrics-watch";
  inherit (repoMeta) version;

  src = fetcher (
    builtins.removeAttrs repoMeta [
      "type"
      "version"
      "vendorHash"
    ]
  );

  vendorHash = repoMeta.vendorHash or (throw "vendorHash missing from ${repoMeta.repo} metadata");

  meta = {
    description = "Metrics watch TUI for Pipelines as Code";
    homepage = "https://github.com/pipelines-as-code/${finalAttrs.pname}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = finalAttrs.pname;
  };
})
