{ lib, ...}:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "cnijfilter2"
    "google-chrome"
    "skypeforlinux"
    "steam"
    "steam-unwrapped"
    "steam-original"
    "steam-runtime"
    "webex"
    "nvidia-x11"
    "nvidia-settings"
    "nvidia-persistenced"
    "spotify"
    "spotify-unwrapped"
    "zoom"
    "teamviewer"
    "widevine-cdm"
    "citrix-workspace"
  ];
}
