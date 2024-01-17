{ pkgs, ... }:

rec {
  generate_ssh_key = pkgs.callPackage ./generate_ssh_key {};
  linux-firmware-x13s = pkgs.callPackage ./x13s-firmware {};
  qrtr = pkgs.callPackage ./qrtr {};
  pd-mapper = pkgs.callPackage ./pd-mapper { inherit qrtr; };
}
