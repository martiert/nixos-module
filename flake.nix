{
  description = "images for creation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    blocklist = {
      url = "github:hagezi/dns-blocklists";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, blocklist, ... }: {
    nixosModules = {
      all = import ./default.nix;
      minimal = import ./minimal.nix;
      home-manager = import ./home-manager.nix;
      default = self.nixosModules.all;
    };
  } //
  flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
  let
    pkgs = import nixpkgs { inherit system; };
    packages = pkgs.callPackages ./packages {
      inherit blocklist;
    };
  in {
    packages = packages;
    hydraJobs = {
      inherit packages;
    };
  }) //
  {
    overlays.default = final: prev: {
    } // self.packages."x86_64-linux" // self.packages."aarch64-linux";
  };
}
