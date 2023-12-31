{
  description = "images for creation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosModules = {
      all = import ./default.nix;
      minimal = import ./minimal.nix;
      home-manager = import ./home-manager.nix;
      default = self.nixosModules.all;
    };
  };
}
