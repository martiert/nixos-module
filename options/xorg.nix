{ lib, configs, ... }:

with lib;

{
  options = {
    martiert.services = {
      waylandOnly = mkOption {
        type = types.bool;
        default = false;
        description = "Disable xserver";
      };
      xserver = {
        defaultSession = mkOption {
          type = types.str;
          default = "sway";
          description = "Default session for sddm";
        };
      };
    };
  };
}
