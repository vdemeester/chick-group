self: super: {
  inherit (super.callPackage ../packages/deptree.nix { }) deptree;
  inherit (super.callPackage ../packages/kss.nix { }) kss;
}
