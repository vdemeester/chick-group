{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gh-news";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "gh-news";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NareNUgN/hrb/7AZeoYwwxa2Wij2bfkebwKI8VsmyQg=";
  };

  cargoHash = "sha256-fkZVrhq/vex62QhYMPk5pW45hlU05m15CXLDYqjC4Nw=";

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
