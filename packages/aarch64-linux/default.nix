{ pkgs, ... }:

{
  lenovo-t14s-firmware = pkgs.callPackage ./lenovo-t14s-firmware.nix { };
}
