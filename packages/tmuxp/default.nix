{ pkgs, fetchPypi, ... }:

pkgs.tmuxp.overrideAttrs (oldAttrs: rec {
  version = "1.56.0";

  src = fetchPypi {
    inherit version;
    pname = oldAttrs.pname;
    hash = "sha256-6Nc6JHNZM6OUgoOfpD4wCDUlLAb2kLBplm1IjuVG/q8=";
  };
})
