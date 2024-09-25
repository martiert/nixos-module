{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.martiert.ssh_config;

  blockToString = name: data: builtins.concatStringsSep "\n" (["Host ${name}"]
      ++ optional data.forwardAgent "  ForwardAgent yes"
      ++ optional (data.port != null) "  Port ${toString data.port}"
      ++ optional data.identitiesOnly "  IdentitiesOnly yes"
      ++ optional (data.user != null) "  User ${data.user}"
      ++ optional (data.hostname != null) "  HostName ${data.hostname}"
      ++ optional (data.addressFamily != null) "  AddressFamily ${data.addressFamily}"
      ++ optional (data.serverAliveInterval != null) "  ServerAliveInterval ${toString data.serverAliveInterval}"
      ++ optional (data.serverAliveCountMax != null) "  ServerAliveCountMax ${toString data.serverAliveCountMax}"
      ++ map (filename: "  IdentityFile ${filename}") data.identityFile
      ++ map (forwards: "  RemoteForward ${forwards.bind} ${forwards.host}") data.remoteForwards
      ++ [""]
      );
in {
  home.file.".ssh/config_source" = {
    enable = cfg.enable;
    onChange = ''cat ~/.ssh/config_source > ~/.ssh/config
      chmod 0400 ~/.ssh/config
'';
    text = builtins.concatStringsSep "\n" (mapAttrsToList blockToString cfg.matchBlocks);
  };
}
