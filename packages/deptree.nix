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
rec {
  deptree = buildGoModule rec {
    pname = "deptree";
    name = "deptree-${repoMeta.version}";
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

    meta = {
      description = "";
      homepage = "https://github.com/vc60er/deptree";
      license = lib.licenses.asl20; # FIXME: use the correct one once there is one
    };
  };
}
