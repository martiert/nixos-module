{ pkgs, lib, ... }:

let
  kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.7.5";
     modDirVersion = version;
     defconfig = "laptop_defconfig";

     src = pkgs.fetchFromGitHub {
       owner = "steev";
       repo = "linux";
       rev = "45411854bb931cb5c989e00ded127d4fc68dfa01";
       hash = "sha256-2FSsuKEl+KTYmiDtgCbxHS7y8Qz+Y1zkRuRcWWE0iqc=";
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
