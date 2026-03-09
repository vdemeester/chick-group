{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tekton-lsp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "vdemeester";
    repo = "tekton-lsp-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a2ckAraNeRzhbnMT38pIi106n//D7cASeNMYktCbzbE=";
  };

  vendorHash = "sha256-1PS0V2No1S5WuvxGlggiFmbYj7W29PSU3wqKntMU9J8=";

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
