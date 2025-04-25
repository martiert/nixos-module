{ pkgs, config, lib, ... }:

with lib;

let
  martiert = config.martiert;
  guiEnabled = builtins.elem martiert.system.type [ "desktop" "laptop" ];
in mkIf guiEnabled {
  services = {
    xserver = {
      enable = true;
      xkb = {
        options = "caps:none,compose:lwin";
        layout = "us";
      };
      windowManager.i3.enable = true;
      wacom.enable = true;
    };
    libinput.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        enableHidpi = builtins.elem martiert.system.type [ "desktop" "laptop" ];
      };
      defaultSession = martiert.services.xserver.defaultSession;
    };
  };

  programs.sway.enable = true;
  hardware.graphics = mkIf (pkgs.system == "x86_64-linux") {
    enable32Bit = true;
  };
  programs.i3lock.enable = true;
}
