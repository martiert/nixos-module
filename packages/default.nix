{ pkgs, stdenv, blocklist, deploy-rs, ... }:

{
  generate_ssh_key = pkgs.callPackage ./generate_ssh_key {};
  mutt-ics = pkgs.callPackage ./mutt-ics {};
  dns_blocklist = pkgs.callPackage ./dns_blocklist { inherit blocklist; };

  flashPrint = pkgs.libsForQt5.callPackage ./flashPrint {}; 
  deploy-rs = deploy-rs.packages."${stdenv.hostPlatform.system}".default;
} // (pkgs.callPackages ./${stdenv.hostPlatform.system} {})
