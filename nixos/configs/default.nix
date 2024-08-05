{ pkgs, lib, config, ... }:

with lib;

let
  martiert = config.martiert;
  isPersonalPC = builtins.elem martiert.system.type [ "desktop" "laptop" ];
in {
  imports = [
    ./xorg.nix
    ./printing.nix
    ./timezone.nix
    ./fonts.nix
    ./networking
  ];

  config = mkIf isPersonalPC {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    documentation.dev.enable = true;

    environment.systemPackages = [
      pkgs.git
      pkgs.nssmdns
      pkgs.man-pages
      pkgs.man-pages-posix
      pkgs.git-crypt
    ];

    nix = {
      package = pkgs.nixVersions.latest;
      extraOptions = ''
        keep-outputs = true
        keep-derivations = true
        experimental-features = nix-command flakes
      '';
    };
  };
}
