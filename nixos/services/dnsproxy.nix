{ config, lib, ... }:

let
  martiert = config.martiert;
in {
  services.dnsmasq = lib.mkIf martiert.dnsproxy.enable {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      conf-file = config.age.secrets."dns_servers".path;
    };
  };
}
