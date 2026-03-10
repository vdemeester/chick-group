{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tekton-lsp";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vdemeester";
    repo = "tekton-lsp-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JjWxj5f82fJ5Td0BKXWBOoz3On1ur7vrAfkY4Eiub6k=";
  };

  vendorHash = "sha256-ufWpZ3UhuhicEqZT+Fs+mOSVcPq7n0A2RrnVcanmKLs=";

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
