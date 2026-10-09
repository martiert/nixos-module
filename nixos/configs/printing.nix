{ pkgs, config, lib, ... }:

let
  martiert = config.martiert;
  printing = martiert.system.type != "server" && pkgs.stdenv.hostPlatform.system == "x86_64-linux";
in {
  services.printing = {
    enable = printing;
    # drivers = [ pkgs.cnijfilter2 ];
  };
}
