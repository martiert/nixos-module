{ pkgs, blocklist, ... }:

rec {
  generate_ssh_key = pkgs.callPackage ./generate_ssh_key {};
  linux-firmware-x13s = pkgs.callPackage ./x13s-firmware {};
  qrtr = pkgs.callPackage ./qrtr {};
  pd-mapper = pkgs.callPackage ./pd-mapper { inherit qrtr; };
  mutt-ics = pkgs.callPackage ./mutt-ics {};
  dns_blocklist = pkgs.callPackage ./dns_blocklist { inherit blocklist; };

  flashPrint = pkgs.libsForQt5.callPackage ./flashPrint {}; 
}
