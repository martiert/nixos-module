{ lib, config, ...}:

lib.mkIf (config.martiert.system.type != "server") {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Martin Ertsås";
        email = "martiert@gmail.com";
      };
      diff = {
        renames = true;
        submodules = "log";
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      grep = {
        lineNumbers = true;
      };
      color = {
        status = "auto";
        branch = "auto";
        diff = "auto";
        ui = "auto";
      };
      push = {
        default = "simple";
      };
      init = {
        defaultBranch = "main";
      };
    };
    signing = {
      signByDefault = true;
      key = null;
    };
    ignores = [
      "TODO"
      "compile_commands.json"
      "shell.nix"
      ".envrc"
      ".ccls-cache"
    ];
    lfs = {
      enable = true;
      skipSmudge = true;
    };
    includes = [
      {
        condition = "gitdir:~/src/Cisco/";
        contents = {
          user = {
            email = "mertsas@cisco.com";
          };
        };
      }
    ];
  };
}
