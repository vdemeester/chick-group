{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  tzdata,
  fzf,
  gawk,
  gum,
  glibc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "batzconverter";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "batzconverter";
    rev = finalAttrs.version;
    hash = "sha256-9tN0fr1FcAxBRDpV5l7N6iAQ+1WOb6gEbpcmahfta5o=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      # glibc.bin provides zdump on Linux; on macOS it's a system utility
      runtimeDeps = [ fzf gawk gum ] ++ lib.optionals stdenv.hostPlatform.isLinux [ glibc.bin ];
    in
    ''
      runHook preInstall

      install -Dm755 batz.sh $out/bin/batz

      # Fix hard-coded zoneinfo path
      sed -i "s|/usr/share/zoneinfo|${tzdata}/share/zoneinfo|g" $out/bin/batz

      # Fix upstream bug: empty extras causes loop to check empty string
      sed -i -E 's/for tool in fzf awk zdump "\$\{extras\}"/for tool in fzf awk zdump \$\{extras\}/' $out/bin/batz

      wrapProgram $out/bin/batz \
        --prefix PATH : ${lib.makeBinPath runtimeDeps}

      runHook postInstall
    '';

  meta = {
    description = "Timezone converter to show times between different timezones";
    homepage = "https://github.com/chmouel/batzconverter";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "batz";
  };
})
