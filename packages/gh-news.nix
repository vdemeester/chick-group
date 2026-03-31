{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gh-news";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "gh-news";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EoJ7SzyQ/t66xhfoxbEQn99aDphNQdQEXN0JNDOz92o=";
  };

  cargoHash = "sha256-sk5d600eSWEr7pngzNdQpAbopkRcaOJz19HfUrSC2ik=";

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
