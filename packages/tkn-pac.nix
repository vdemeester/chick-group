{ stdenv, lib, buildGoModule, fetchFromGitHub }:

with lib;
rec {
  tknPacGen = { version, sha256 }:
    buildGoModule rec {
      pname = "tkn-pac";
      name = "${pname}-${version}";

      subPackages = [ "cmd/tkn-pac" ];
      ldflags = [
        "-s"
        "-w"
        "-X github.com/openshift-pipelines/pipelines-as-code/pkg/params/version.Version=${version}"
      ];
      src = fetchFromGitHub {
        owner = "openshift-pipelines";
        repo = "pipelines-as-code";
        rev = "v${version}";
        sha256 = "${sha256}";
      };
      vendorHash = null;
      doCheck = false;

      postInstall = ''
        # manpages
        manRoot="$out/share/man"
        mkdir -p "$manRoot/man1"
        for manFile in docs/man/man1/*; do
          manName="$(basename "$manFile")" # "docker-build.1"
          gzip -c "$manFile" > "$manRoot/man1/$manName.gz"
        done
        # completions
        mkdir -p $out/share/bash-completion/completions/
        $out/bin/tkn-pac completion bash > $out/share/bash-completion/completions/tkn-pac
        mkdir -p $out/share/zsh/site-functions
        $out/bin/tkn-pac completion zsh > $out/share/zsh/site-functions/_tkn-pac
      '';
      meta = with lib; {
        homepage = https://github.com/openshift-pipelines/pipelines-as-code;
        description = "A Tekton CLI extension for managing pipelines-as-code repositories and bootstrapping";
        license = licenses.asl20;
        maintainers = with maintainers; [ vdemeester ];
      };
    };

  tkn-pac = tkn-pac_0_22;
  tkn-pac_0_22 = makeOverridable tknPacGen {
    version = "0.22.4";
    sha256 = "sha256-BaGZ0cVhPAkGd5iqqAh6BgMGziuDpLPz7w1C4a1DGVM=";
  };
  tkn-pac_0_21 = makeOverridable tknPacGen {
    version = "0.21.5";
    sha256 = "sha256-cnP4oBV0ElTO2e1H0GT1nhKHoqvMv9kXJd8rfK19qYo=";
  };
  tkn-pac_0_20 = makeOverridable tknPacGen {
    version = "0.20.0";
    sha256 = "sha256-zYzlcgPpO0JvF2viDdiXOpEu5JH08oo0Mv9inYP1Als=";
  };
}
