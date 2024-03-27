self: super:
{
  inherit (super.callPackage ../packages/deptree.nix { }) deptree;
  inherit (super.callPackage ../packages/kss.nix { }) kss;
  inherit (super.callPackage ../packages/tkn-pac.nix { })
    tkn-pac
    tkn-pac_0_25
    tkn-pac_0_24
    tkn-pac_0_23
    tkn-pac_0_22
    tkn-pac_0_21
    tkn-pac_0_20
    ;
}
