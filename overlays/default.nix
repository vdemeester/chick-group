self: super: {
  inherit (super.callPackage ../packages/deptree.nix { }) deptree;
  inherit (super.callPackage ../packages/kss.nix { }) kss;
  inherit (super.callPackage ../packages/startpaac.nix { }) startpaac;
}
