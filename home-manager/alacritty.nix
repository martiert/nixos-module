{ lib, config, ... }:

let
  cfg = config.martiert;
in lib.mkIf (config.martiert.system.type != "server") {
  programs.alacritty = {
    enable = (cfg.terminal.default == "alacritty");
    settings = {
      window.decorations = "none";

      font = {
        size = cfg.terminal.fontSize;
      };

      colors = {
        primary = {
          background = "#000000";
        };

        normal = {
          green = "#75bd64";
        };
      };
    };
  };
}
