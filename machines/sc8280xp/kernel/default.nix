{ pkgs, buildLinux, ... }@args:

let
  steev_kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.5.5";
     modDirVersion = version;
     # defconfig = ./defconfig;
     defconfig = "laptop_defconfig";

     src = pkgs.fetchFromGitHub {
       owner = "steev";
       repo = "linux";
       rev = "4f960402118224ab18a45f4a4e698f69b024b6af";
       sha256 = "wTLnqLbJ1tCzyyDq0peFCHolN5oj6aL0Wb2dEZY7zwQ=";
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
