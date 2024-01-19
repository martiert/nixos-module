{ pkgs, lib, buildLinux, ... }@args:

let
  steev_kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.6.11";
     modDirVersion = version;
     # defconfig = ./defconfig;
     defconfig = "laptop_defconfig";

     src = pkgs.fetchFromGitHub {
       owner = "steev";
       repo = "linux";
       rev = "48e40671c262d6b4ed199290d6c8d8631f8f7970";
       hash = "sha256-vvT92Y7KVhrdqmGOxWoYTixBSMzzgvZ4U81v/Uz2FtI=";
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
