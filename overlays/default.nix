_self: super: {
  deptree = super.callPackage ../packages/deptree.nix { };
  kss = super.callPackage ../packages/kss.nix { };
  startpaac = super.callPackage ../packages/startpaac.nix { };
}
