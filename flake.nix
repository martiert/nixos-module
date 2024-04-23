{
  description = "images for creation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    blocklist = {
      url = "github:hagezi/dns-blocklists";
      flake = false;
    };
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, flake-utils, blocklist, deploy-rs, ... }: {
    nixosModules = {
      all = import ./default.nix;
      minimal = import ./minimal.nix;
      home-manager = import ./home-manager.nix;
      default = self.nixosModules.all;
    };
    overlays = {
      default = self.overlays.x86_64-linux;
    } //
    flake-utils.lib.eachSystemMap [ "x86_64-linux" "aarch64-linux" ] (system: (final: prev: self.packages."${system}"));
  } //
  flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
  let
    pkgs = import nixpkgs { inherit system; };
    packages = pkgs.callPackages ./packages {
      inherit blocklist deploy-rs;
    };
  in {
    packages = packages;
    hydraJobs = {
      inherit packages;
    };
  });
}
