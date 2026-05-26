{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gh-news";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "gh-news";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ztHvgS4O1f+mDq/WMKz+ojH44/7SYTGhF84f3DsRywU=";
  };

  cargoHash = "sha256-NzymyDf5bJBhmmuELulFrazyhFwAeD8VX1OORjWAIKw=";

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
