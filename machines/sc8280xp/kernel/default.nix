{ pkgs, buildLinux, ... }@args:

let
  steev_kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.5.0";
     modDirVersion = version;
     # defconfig = ./defconfig;
     defconfig = "laptop_defconfig";

     src = pkgs.fetchFromGitHub {
       owner = "steev";
       repo = "linux";
       rev = "f8016454e0c5020de8dc00023cbeea3faac885a5";
       sha256 = "yOyXxScyCBvVxQvuvOTthD32a/S752baZQWpu8aHuEY=";
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
