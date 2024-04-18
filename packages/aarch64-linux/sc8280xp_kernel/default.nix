{ pkgs, lib, ... }:

let
  kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.8.5";
     modDirVersion = version;
     defconfig = "laptop_defconfig";

     src = pkgs.fetchFromGitHub {
       owner = "steev";
       repo = "linux";
       rev = "58a46f49aaf7d978d8a8883137a41ad21f8e8f84";
       hash = "sha256-HQeDMvTNEo8/SaioZhlkuzcDwfbqFhaJR/5d4y2dvgg=";
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
