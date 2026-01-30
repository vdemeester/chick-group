{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-better-html-coverage";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "go-better-html-coverage";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MVqGDJqUO6z4Y6UUOEluOlmtzframAr5pNm2M+i1ykQ=";
  };

  vendorHash = "sha256-5umbEePN6C+NW8QwmvMYvgDtpv0IH9jkP0ip94SFPH0=";

  # Relax Go version requirement (1.25.6 -> 1.25)
  postPatch = ''
    sed -i 's/go 1.25.6/go 1.25/' go.mod
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Better HTML Go Coverage - Single-file HTML coverage reports for Go";
    homepage = "https://github.com/chmouel/${finalAttrs.pname}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "go-better-html-coverage";
  };
})
