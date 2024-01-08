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
            rev = "e8c3e7792336e9f68aa560db8ad19ba06ba786bb";
            hash = "sha256-4fIvgHIkTyGApM3uvucFPSYMMGYR5vjHOz6KQ26Kg7A=";
          };
          patches = [ ./unfix-device-numbers.patch ];
        });
        modemmanager = prev.modemmanager.overrideAttrs (old: {
          patches = old.patches ++ [
            ./0001-fcc-unlock-add-link-for-new-T99W175-5G-modem-variant.patch
          ];
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
