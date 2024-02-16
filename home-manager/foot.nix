{ lib, config, ... }:

let
  cfg = config.martiert;
in lib.mkIf (config.martiert.system.type != "server") {
  programs.foot = {
    enable = (cfg.terminal.default == "foot");
    settings = {
      main = {
        dpi-aware = "yes";
      };
    };
  };
}
