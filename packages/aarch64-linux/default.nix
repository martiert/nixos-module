{ pkgs, ... }:

let
  sc8280xpKernel = pkgs.callPackage ../../machines/sc8280xp/kernel {};
in
rec {
  sc8280xp_kernel = pkgs.callPackage ./sc8280xp_kernel {};
}
