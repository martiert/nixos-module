{ pkgs, lib, config, ... }:

lib.mkIf (config.martiert.system.aarch64.arch == "sc8280xp") {
  services.pulseaudio.enable = false;

  services.upower.enable = true;
  hardware.bluetooth.disabledPlugins = [
    "sap"
  ];

  systemd.services = {
    bluetooth = {
      serviceConfig = {
        ExecStartPre = [
          ""
          "${pkgs.util-linux}/bin/rfkill block bluetooth"
          "${pkgs.bluez5-experimental}/bin/btmgmt public-addr D4:C2:0D:30:A2:44"
          "${pkgs.util-linux}/bin/rfkill unblock bluetooth"
        ];
        RestartSec=5;
        Restart="on-failure";
      };
    };
  };
}
