{ pkgs, ... }:

{
  lenovo-t14s-firmware = pkgs.callPackage ./lenovo-t14s-firmware.nix { };
  t14s-kernel = pkgs.callPackage ./t14s-kernel {};
}
