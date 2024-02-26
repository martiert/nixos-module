{ pkgs, ... }:

let
  sc8280xpKernel = pkgs.callPackage ../../machines/sc8280xp/kernel {};
in
rec {
  linux-firmware-x13s = pkgs.callPackage ./x13s-firmware {};
  qrtr = pkgs.callPackage ./qrtr {};
  pd-mapper = pkgs.callPackage ./pd-mapper { inherit qrtr; };
  sc8280xp_kernel = pkgs.callPackage ./sc8280xp_kernel {};
}
