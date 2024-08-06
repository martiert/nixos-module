{ config, lib, pkgs, ... }:

let
in lib.mkIf config.martiert.services.duo.enable {
  systemd.services.duo-desktop = {
    enable = true;
    description = "Duo Desktop";

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.duo}/bin/duo-desktop";
      Type = "simple";
      Restart = "on-failure";
      CapabilityBoundingSet = "CAP_DAC_OVERRIDE CAP_NET_ADMIN CAP_NET_RAW CAP_SYS_ADMIN CAP_SYS_PTRACE";
      NoNewPrivileges = "yes";
      ProtectKernelModules = "yes";
      ProtectKernelTunables = "yes";
      RestrictAddressFamilies = "AF_UNIX AF_LOCAL AF_INET AF_NETLINK AF_INET6";
      RestrictRealtime = "yes";
      ProtectControlGroups = "yes";
      RestrictSUIDSGID = "yes";
      LockPersonality = "yes";
    };
  };
}
