{ pkgs, stdenv, blocklist, ... }:

rec {
  generate_ssh_key = pkgs.callPackage ./generate_ssh_key {};
  mutt-ics = pkgs.callPackage ./mutt-ics {};
  dns_blocklist = pkgs.callPackage ./dns_blocklist { inherit blocklist; };

  flashPrint = pkgs.libsForQt5.callPackage ./flashPrint {}; 
} // (pkgs.callPackages ./${stdenv.hostPlatform.system} {})
