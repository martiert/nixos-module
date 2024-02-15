{ config, lib, ... }:

with lib;

let
  cfg = config.martiert.mountpoints;
in {
  boot.initrd.systemd.enable = true;
  boot.initrd.luks = mkIf (cfg.root != null) {
    devices."root" = {
      device = cfg.root.encryptedDevice;
      crypttabExtraOpts = [] ++
        (optionals cfg.root.useFido2Device [ "fido2-device=auto" ]) ++
        (optionals cfg.root.useTpm2Device [ "tmp2-device=auto" ]);
    };
  };
  fileSystems."/" = mkIf (cfg.root != null) {
    device = "/dev/mapper/root";
    fsType = "ext4";
  };
  fileSystems."/boot" = mkIf (cfg.boot != null) {
    device = cfg.boot;
    fsType = "vfat";
  };

  swapDevices = mkIf (cfg.swap != null) [{
    device = cfg.swap;
    randomEncryption = true;
  }];
}
