self: super:
{
  inherit (super.callPackage ../packages/deptree.nix { }) deptree;
  inherit (super.callPackage ../packages/kss.nix { }) kss;
  inherit (super.callPackage ../packages/tkn-pac.nix { })
    tkn-pac
    tkn-pac_0_28
    tkn-pac_0_27
    tkn-pac_0_26
    tkn-pac_0_25
    tkn-pac_0_24
    ;
}
