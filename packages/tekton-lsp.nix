{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tekton-lsp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "vdemeester";
    repo = "tekton-lsp-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2pxByA7guQ8BDx72dFLPmDdekZguu7WYE9ecXFX+ccY=";
  };

  vendorHash = "sha256-t/cd7b/1QT57Uwv0Zu77OVigaeHduIcgJfyO1948joY=";

  # tree-sitter Go bindings use CGO with #include of C sources
  # outside the Go package dir; proxyVendor fetches full modules
  proxyVendor = true;

  subPackages = [ "cmd/tekton-lsp" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tekton Language Server Protocol implementation in Go";
    homepage = "https://github.com/vdemeester/tekton-lsp-go";
    changelog = "https://github.com/vdemeester/tekton-lsp-go/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "tekton-lsp";
  };
})
