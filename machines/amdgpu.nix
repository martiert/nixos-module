{ pkgs, lib, config, ... }:

with lib;

let
  martiert = config.martiert;
in mkIf (martiert.system.gpu == "amd") {
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];
  hardware.graphics = {
    extraPackages = [
      pkgs.rocm-opencl-icd
      pkgs.rocm-opencl-runtime
    ];
    enable32Bit = true;
  };
}
