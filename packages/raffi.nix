{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  fuzzel,
  wayland,
  libxkbcommon,
  additionalPrograms ? [ ],
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raffi";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "raffi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P19TXhv4LxFRg4MD60CSMqettkDmQgcK6r6LEfsuEcw=";
  };

  cargoHash = "sha256-XSsfmscn5qzCJWoXV4AIlYJJsSBFdvv2mimPECpFku0=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  checkFlags = [
    "--skip=tests::test_read_config_from_reader"
    "--skip=tests::test_addons_config_parsing"
    "--skip=tests::test_config_without_general_section"
    "--skip=tests::test_general_config_parsing"
    "--skip=tests::test_partial_general_config"
  ];

  postFixup = ''
    wrapProgram $out/bin/raffi \
      --prefix PATH : ${lib.makeBinPath ([ fuzzel ] ++ additionalPrograms)} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
        ]
      }
  '';

  meta = {
    description = "Fuzzel launcher based on yaml configuration";
    homepage = "https://github.com/chmouel/raffi";
    changelog = "https://github.com/chmouel/raffi/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "raffi";
    platforms = lib.platforms.linux;
  };
})
