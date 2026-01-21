_self: super: {
  deptree = super.callPackage ../packages/deptree.nix { };
  gh-news = super.callPackage ../packages/gh-news.nix { };
  kss = super.callPackage ../packages/kss.nix { };
  startpaac = super.callPackage ../packages/startpaac.nix { };
}
