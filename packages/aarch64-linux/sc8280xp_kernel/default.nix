{ pkgs, lib, ... }:

let
  kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.9.2";
     modDirVersion = version;
     defconfig = "johan_defconfig";

     src = pkgs.fetchFromGitHub {
       owner = "steev";
       repo = "linux";
       rev = "4ad79d624a0a64db0b59f60b4c2225c8a5b92f96";
       hash = "sha256-2lgDyPOFjGj143CSbSHL5cqJhQIQj0Grbcpno1JVhGo=";
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
