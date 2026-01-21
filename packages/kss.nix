{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kss";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "kss";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P5FUYc8pxqDKsos2l1oQ8RpmStZleg2aU9r2NN/K9L4=";
  };

  vendorHash = "sha256-HutPOas0oO3nvpW9+Thg89lYvknv4/KWucsKtwYVnhg=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Build both kss and tkss
  subPackages = [
    "cmd/kss"
    "cmd/tkss"
  ];

  meta = {
    description = "Enhanced Kubernetes Pod Inspection tool with TUI dashboard";
    homepage = "https://github.com/chmouel/${finalAttrs.pname}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "kss";
  };
})
