{
  description = "images for creation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: {
    nixosModules = {
      all = import ./default.nix;
      minimal = import ./minimal.nix;
      home-manager = import ./home-manager.nix;
      default = self.nixosModules.all;
    };
  } //
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
    packages = pkgs.callPackages ./packages {};
  in {
    packages = packages;
    overlays.default = final: super: {
    } // packages;
  });
}
