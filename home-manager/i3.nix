{ pkgs, lib, config, ...}:

with lib;

let
  cfg = config.martiert;
  modifier = config.xsession.windowManager.i3.config.modifier;
  terminal = if (cfg.terminal.default == "alacritty") then "${pkgs.alacritty}/bin/alacritty" else "${pkgs.xterm}/bin/xterm";
in lib.mkIf (config.martiert.system.type != "server") {
  xsession.windowManager.i3 = {
    enable = cfg.i3.enable;
    config = {
      modifier = "Mod1";
      terminal = terminal;
      menu = "${pkgs.bemenu}/bin/bemenu-run";
      keybindings = mkOptionDefault {
        "${modifier}+Shift+l"     = "exec ${cfg.i3.lockCmd}";
      };
      bars = [
        {
          trayOutput = "*";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs config-bottom.toml";
          fonts = {
            names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
            size = cfg.i3.barSize;
          };
        }
      ];
      colors.background = "#000000";
    };
  };
  services.picom = {
    enable = true;
    vSync = true;
  };
  services.screen-locker = {
    enable = true;
    inactiveInterval = 10;
    lockCmd = cfg.i3.lockCmd;
  };
}
