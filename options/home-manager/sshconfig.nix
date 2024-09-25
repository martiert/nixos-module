{ pkgs, lib, ... }:

with lib;

let
  remoteForwards = types.submodule {
    options = {
      host = mkOption {
        type = types.str;
      };
      bind = mkOption {
        type = types.str;
      };
    };
  };

  hostBlock = types.submodule {
    options = {
      identitiesOnly = mkOption {
        type = types.bool;
        default = true;
      };
      identityFile = mkOption {
        type = types.either (types.listOf types.str) (types.nullOr types.str);
        default = [];
        apply = p: if p == null then [ ] else if isString p then [ p ] else p;
      };
      user = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      hostname = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      port = mkOption {
        type = types.nullOr types.port;
        default = null;
      };
      addressFamily = mkOption {
        type = types.nullOr (types.enum [ "any" "inet" "inet6" ]);
        default = null;
      };
      serverAliveInterval = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
      serverAliveCountMax = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
      forwardAgent = mkOption {
        type = types.bool;
        default = false;
      };
      remoteForwards = mkOption {
        type = types.listOf remoteForwards;
        default = [];
      };
    };
  };
in {
  options = {
    martiert.ssh_config = {
      enable = mkEnableOption "Enable the ssh config";
      matchBlocks = mkOption {
        type = types.attrsOf hostBlock;
        default = {};
      };
    };
  };
}
