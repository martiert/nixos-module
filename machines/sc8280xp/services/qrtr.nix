{ stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  pname = "qrtr";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "andersson";
    repo = "qrtr";
    rev = "9dc7a88548c27983e06465d3fbba2ba27d4bc050";
    sha256 = "sha256-eJyErfLpIv4ndX2MPtjLTOQXrcWugQo/03Kz4S8S0xw=";
  };

  makeFlags = ["prefix=${placeholder "out"}"];
}
