{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
  fuzzel,
  wayland,
  libxkbcommon,
  additionalPrograms ? [ ],
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "raffi";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "raffi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vi+NbRRknyzbHVAeGrVyYrwCS+orY7A3Ya6/rrexhCE=";
  };

  cargoHash = "sha256-ApyblqfR+hmIYKoSaxhL56V7ulfnTm27rOAmhu4qXug=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # Several tests use `firefox` in their config fixtures. The test parses configs
    # via `read_config_from_reader` which validates that referenced binaries exist
    # in PATH, filtering out entries with missing binaries. Provide a stub so these
    # tests can run in the sandbox.
    mkdir -p "$TMPDIR/fake-bin"
    touch "$TMPDIR/fake-bin/firefox"
    chmod +x "$TMPDIR/fake-bin/firefox"
    export PATH="$TMPDIR/fake-bin:$PATH"
  '';

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
