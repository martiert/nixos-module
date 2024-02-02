{ lib, config, ... }:

lib.mkIf (config.martiert.system.type != "server") {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "yes";
      };
    };
  };
}
