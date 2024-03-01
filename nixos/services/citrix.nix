{ pkgs, lib, config, ... }:

let
  martiert = config.martiert;
in lib.mkIf martiert.citrix.enable {
  nixpkgs.overlays = [
    (final: prev: {
      citrix_workspace = prev.citrix_workspace.overrideAttrs (old: {
        autoPatchelfIgnoreMissingDeps = [
          "*"
        ];
      });
    })
  ];

  environment.systemPackages = [
    pkgs.citrix_workspace
  ];

  systemd.services."ctxcwalogd" = {
    enable = true;
    description = "Citrix Log Daemon Service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart="${pkgs.citrix_workspace}/opt/citrix-icaclient/util/ctxcwalogd";
      User="citrixlog";
    };
  };

  users = {
    users.citrixlog = {
      isSystemUser = true;
      group = "citrixlog";
      shell = "/bin/sh";
      home = "/var/log/citrix";
      createHome = true;
    };
    groups = {
      citrixlog = {};
      citrix = {};
    };
  };
}
