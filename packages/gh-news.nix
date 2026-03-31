{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gh-news";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "gh-news";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GkM4/BxDfIMwqk45ZwYcp79vcz8dYekq35AUp3vC9QY=";
  };

  cargoHash = "sha256-BpJdPL4nZs7FgnwZjmXahDg4AXOsMR1zVzZTNGEgXtE=";

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
