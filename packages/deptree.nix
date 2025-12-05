{ lib
, buildGoModule
, fetchFromGitHub
,
}:

let
  repoMeta = lib.importJSON ../repos/deptree-main.json;
  fetcher =
    if repoMeta.type == "github" then
      fetchFromGitHub
    else
      throw "Unknown repository type ${repoMeta.type}";
in
buildGoModule rec {
  pname = "deptree";
  version = "${repoMeta.version}";

  src = fetcher (
    builtins.removeAttrs repoMeta [
      "type"
      "version"
      "vendorHash"
    ]
  );
  # FIXME: support generating that hash in repos/update
  vendorHash = "sha256-k2TXOedsF4dDUqltq9CGLdMd303I7AHRvODA88U3xw0=";

  meta = with lib; {
    description = "Dependency tree visualization tool";
    homepage = "https://github.com/vc60er/deptree";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "deptree";
  };
}
