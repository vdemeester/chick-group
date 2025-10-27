{ lib
, fetchFromGitHub
, stdenv
,
}:
let
  repoMeta = lib.importJSON ../repos/startpaac-main.json;
  fetcher =
    if repoMeta.type == "github" then
      fetchFromGitHub
    else
      throw "Unknown repository type ${repoMeta.type}";
in
rec {
  startpaac = stdenv.mkDerivation rec {
    pname = "startpaac";
    name = "startpaac-${repoMeta.version}";
    version = "${repoMeta.version}";

    src = fetcher (
      builtins.removeAttrs repoMeta [
        "type"
        "version"
        "vendorHash"
      ]
    );

    installPhase = ''
      mkdir -p $out/bin $out/share/startpaac
      cp -Rv lib $out/share/startpaac

      pwd
      ls -l

      # patch startpacc to load from $out/share/startpaac
      sed --in-place "s%^Miself=.*$%Miself=$out/bin/startpaac%g" startpaac
      sed --in-place "s%^SP=.*$%SP=$out/share/startpaac%g" startpaac

      cp -v startpaac $out/bin
      chmod +x $out/bin/startpaac

    '';

    meta = {
      description = "StartPAAC - All in one setup for Pipelines as Code on Kind ";
      homepage = "https://github.com/chmouel/startpaac";
      license = lib.licenses.asl20; # FIXME: use the correct one once there is one
    };
  };
}
