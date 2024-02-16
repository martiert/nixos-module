{ lib, ... }:

with lib;

{
  imports = [
    ./i3status.nix
    ./mail.nix
  ];

  options.martiert = {
    terminal = {
      default = mkOption {
        type = types.str;
        default = "alacritty";
        description = "Default terminal to use";
      };
      fontSize = mkOption {
        type = types.int;
        default = 10;
        description = "Fontsize to use";
      };
    };
  };
}
