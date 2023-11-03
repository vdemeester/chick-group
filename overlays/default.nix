self: super:
{
  inherit (super.callPackage ../packages/deptree.nix { }) deptree;
}
