{ stdenv, fetchFromGitHub, qrtr, ... }:

stdenv.mkDerivation {
  pname = "pd-mapper";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "cenunix";
    repo = "pd-mapper";
    rev = "8db3b693572016f986639eb2e2976b5ab3766409";
    sha256 = "wWIGXWrZ9ajvcW4JR3MBq4jYWNwGKf7s9GarYYvrXzQ=";
  };

  buildInputs = [ qrtr ];

  makeFlags = ["prefix=${placeholder "out"}"];
}
