{ lib, config, ... }:

lib.mkIf (config.martiert.system.type != "server") {
  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "hkps://keys.openpgp.org";
    };
    publicKeys = [
      {
        source = ./keys.pub;
        trust = "ultimate";
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";
    enableSshSupport = true;
  };
}
