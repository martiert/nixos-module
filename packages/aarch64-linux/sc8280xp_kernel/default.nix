{ pkgs, lib, ... }:

let
  kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.8.9";
     modDirVersion = version;
     defconfig = "laptop_defconfig";

     src = pkgs.fetchFromGitHub {
       owner = "steev";
       repo = "linux";
       rev = "d6c0993fc013b17e0b1bbed172554b0f1cba0bfd";
       hash = "sha256-Z35n8rah4z1eL4+JvlI//cpH2TzXYTDf7r0SvrTGDcE=";
     };

     kernelPatches = [
       {
         name = "Add firmware";
         patch = ./add_firmware.patch;
         extraConfig = "";
       }
     ];
     structuredExtraConfig = {
       VIDEO_AR1337 = lib.kernel.no;
     };
   } // (args.argsOverride or {}));
in
  pkgs.callPackage kernel_pkg {}
