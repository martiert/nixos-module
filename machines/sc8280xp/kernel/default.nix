{ pkgs, buildLinux, ... }@args:

let
  steev_kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.4.3";
     modDirVersion = version;
     # defconfig = ./defconfig;
     defconfig = "laptop_defconfig";

     src = pkgs.fetchFromGitHub {
       owner = "steev";
       repo = "linux";
       rev = "0aa161bf684fa6a1db16a851eefd541cab48b282";
       sha256 = "gwl1tPa7p+kRRbI5Bjobs+jVzXa0iI2TI0BynqV3tOU=";
     };
     kernelPatches = [
       {
         name = "Add firmware";
         patch = ./add_firmware.patch;
         extraConfig = "";
       }
     ];
   } // (args.argsOverride or {}));
  steev_kernel = pkgs.callPackage steev_kernel_pkg {};
in
  pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor steev_kernel)
