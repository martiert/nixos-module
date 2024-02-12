{ pkgs, lib, buildLinux, ... }@args:

let
  steev_kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.6.12";
     modDirVersion = version;
     defconfig = "laptop_defconfig";

     src = pkgs.fetchFromGitHub {
       owner = "steev";
       repo = "linux";
       rev = "0d6a5d6312e4ad69b18d699c48ee93a9ba564dfb";
       hash = "sha256-dyItbyfVmcwJw/i/KYHRMrXbO6JSmQEckxFD66jRBm0=";
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
