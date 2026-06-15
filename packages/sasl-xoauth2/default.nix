{ stdenv
, fetchFromGitHub
, lib
, cmake
, pkg-config
, curl
, python3
, python3Packages
, pandoc
, pkgs
, ... }:

let
  python = python3.withPackages (ps: with ps; [
    msal
  ]);
in stdenv.mkDerivation rec {
  name = "sasl-xoauth2";
  version = "0.27";

  src = fetchFromGitHub {
    owner = "tarickb";
    repo = name;
    rev = "release-${version}";
    hash = "sha256-GUdt39DNtYZl4qsnhnWufXOgu5Mg1+HCJap8IfFyldk=";
  };

  buildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    python
    curl
    pandoc
    pkgs.jsoncpp
    pkgs.cyrus_sasl
  ];
}
