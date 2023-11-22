{ pkgs, lib, config, ... }:

lib.mkIf (config.martiert.system.aarch64.arch == "sc8280xp") {
  nixpkgs = {
    overlays = [
      (final: prev: {
        qrtr = prev.callPackage ./qrtr.nix {};
        pd-mapper = prev.callPackage ./pd-mapper.nix {};
        compressFirmwareXz = lib.id; # pd-mapper needs firmware to not be compressed
        alsa-ucm-conf = prev.alsa-ucm-conf.overrideAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "Srinivas-Kandagatla";
            repo = "alsa-ucm-conf";
            rev = "39420b066a927833809265d2e448da5a8f8ec125";
            sha256 = "y1KFR8KAV+i6ZSrQD2Kriwe1jGw502BvEk9TWjSCcbg=";
          };
          patches = [ ./unfix-device-numbers.patch ];
        });
      })
    ];
  };

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