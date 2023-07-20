{ pkgs, lib, config, ... }:

lib.mkIf (config.martiert.system.aarch64.arch == "sc8280xp") {
  nixpkgs = {
    overlays = [
      (final: prev: {
        qrtr = prev.callPackage ./qrtr.nix {};
        pd-mapper = prev.callPackage ./pd-mapper.nix {};
        compressFirmwareXz = lib.id; # pd-mapper needs firmware to not be compressed
      })
    ];
  };

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
    };
    qrtr = {
      serviceConfig = {
        ExecStart = "${pkgs.qrtr}/bin/qrtr-ns -f 1";
        Restart = "always";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
