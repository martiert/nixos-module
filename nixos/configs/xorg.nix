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

      libinput.enable = true;

      windowManager.i3.enable = true;
      wacom.enable = true;
    };
    displayManager = {
      sddm = {
        enable = true;
        enableHidpi = builtins.elem martiert.system.type [ "desktop" "laptop" ];
      };
      defaultSession = martiert.services.xserver.defaultSession;
    };
  };

  programs.sway.enable = true;
  hardware.opengl = mkIf (pkgs.system == "x86_64-linux") {
    driSupport32Bit = true;
  };
}
