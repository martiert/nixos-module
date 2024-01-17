{ stdenv, fetchFromGitHub, blocklist, ... }:

stdenv.mkDerivation {
  pname = "blocklist";
  version = "1.0.0";

  src = blocklist;

  configPhase = true;
  buildPhase = "";
  installPhase = ''
    mkdir $out
    cp unbound/* $out/
  '';
}
