{ stdenv
, lib
, python3
, fetchFromGitHub
,
}:

stdenv.mkDerivation rec {
  pname = "kss";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "kss";
    rev = "${version}";
    sha256 = "sha256-xads3kMMuN4s2fgJDtint2XnCeVv83GQCxlxhO5Os1k=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall

    substituteInPlace kss --replace \
        "fileout.write(('#!/usr/bin/env %s\n' % env).encode('utf-8'))" \
        "fileout.write(('#!%s/bin/%s\n' % (os.environ['python3'], env)).encode('utf-8'))"

    mkdir -p $out/bin
    cp kss $out/bin

    # completions
    mkdir -p $out/share/zsh/site-functions
    cp _kss $out/share/zsh/site-functions/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Kubernetes Secret Switcher";
    homepage = "https://github.com/chmouel/kss";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "kss";
  };
}
