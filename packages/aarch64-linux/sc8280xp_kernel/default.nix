{ pkgs, lib, ... }:

let
  kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.10.6";
     modDirVersion = version;
     defconfig = "defconfig";

     src = pkgs.fetchFromGitHub {
       owner = "steev";
       repo = "linux";
       rev = "dcc28592778a6a65f462becf0bc57813810f7dde";
       hash = "sha256-AYBUw5tTklVJZOlC/aKEeIJo4Qz2TtFiYPS2bzM9tDs=";
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
