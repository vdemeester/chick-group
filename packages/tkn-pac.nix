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

  tkn-pac = tkn-pac_0_28;
  tkn-pac_0_28 = makeOverridable tknPacGen {
    version = "0.28.0";
    sha256 = "sha256-fp1X2oYPHp4ISgRDn/JKWm17i1kA/JBbV4i1QQ4VZh0=";
  };
  tkn-pac_0_27 = makeOverridable tknPacGen {
    version = "0.27.2";
    sha256 = "sha256-R71qcgWG/TgjeTdnAkMtCTnCNHsRoFZt5KiR+WXTcDk=";
  };
  tkn-pac_0_26 = makeOverridable tknPacGen {
    version = "0.26.0";
    sha256 = "sha256-mw4KVqqB620iycw2B9MFEMJMuQhA2FOVo0vWoRenqKM=";
  };
  tkn-pac_0_25 = makeOverridable tknPacGen {
    version = "0.25.0";
    sha256 = "sha256-Y4Zms7Vn1UEZJ2aQrBZGbIFrdb+q7xXXqoy7SJgLkIo=";
  };
  tkn-pac_0_24 = makeOverridable tknPacGen {
    version = "0.24.7";
    sha256 = "sha256-cnWr0caZKc6xe4zTr3fDnCi4Knftkfx2rDievhqEpf4=";
  };
}
