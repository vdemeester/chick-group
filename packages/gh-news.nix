{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gh-news";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "gh-news";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k63SOsyQN5Qk2wa8hvIBA8jy5tcZwaIq2OqAjpUeuX0=";
  };

  cargoHash = "sha256-pDlSncsWgWt227vVE/+/fQ5qoEPKwMhCKwrR9RB1d10=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "GitHub CLI extension to read your GitHub notifications in the terminal";
    homepage = "https://github.com/chmouel/${finalAttrs.pname}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = finalAttrs.pname;
  };
})
