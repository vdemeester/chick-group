{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  pkg-config,
  fuzzel,
  wayland,
  libxkbcommon,
  additionalPrograms ? [ ],
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raffi";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "raffi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/AiFVTygzOzZei1WbS9ojiPUanhezksWCp4uLkWBCvA=";
  };

  cargoHash = "sha256-hHWjrFQMATHrpFierN5gkyyenOukiMm10hB49r1rmcM=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    wayland
    libxkbcommon
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
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ wayland libxkbcommon ]}
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
