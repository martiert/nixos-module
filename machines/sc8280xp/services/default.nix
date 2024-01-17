{ pkgs, lib, config, ... }:

let
  alsa-ucm-conf' = pkgs.alsa-ucm-conf.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "Srinivas-Kandagatla";
      repo = "alsa-ucm-conf";
      rev = "e8c3e7792336e9f68aa560db8ad19ba06ba786bb";
      hash = "sha256-4fIvgHIkTyGApM3uvucFPSYMMGYR5vjHOz6KQ26Kg7A=";
    };
    patches = [ ./unfix-device-numbers.patch ];
  });
  extraEnv = {
    ALSA_CONFIG_UCM2 = "${alsa-ucm-conf'}/share/alsa/ucm2";
  };
in lib.mkIf (config.martiert.system.aarch64.arch == "sc8280xp") {
  nixpkgs = {
    overlays = [
      (final: prev: {
        compressFirmwareXz = lib.id; # pd-mapper needs firmware to not be compressed
      })
    ];
  };

  hardware.pulseaudio.enable = false;

  environment.variables = extraEnv;
  systemd.user.services.pipewire.environment = extraEnv;
  systemd.user.services.wireplumber.environment = extraEnv;

  services.upower.enable = true;
  hardware.bluetooth.disabledPlugins = [
    "sap"
  ];

  systemd.services = {
    pd-mapper = {
      unitConfig = {
        Requires = "qrtr.service";
        After = "qrtr.service";
      };
      serviceConfig = {
        ExecStart = "${pkgs.pd-mapper}/bin/pd-mapper";
        Restart = "always";
      };
      wantedBy = ["multi-user.target"];
      before = ["upower.service"];
    };
    qrtr = {
      serviceConfig = {
        ExecStart = "${pkgs.qrtr}/bin/qrtr-ns -f 1";
        Restart = "always";
      };
      wantedBy = ["multi-user.target"];
    };
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
