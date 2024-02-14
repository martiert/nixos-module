{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, qt5
, libGLU
, libGL
, glibc
, udev
}:

stdenv.mkDerivation rec {
  name = "flashPrint";

  version = "5.8.3";

  src = fetchurl {
    url = "https://en.fss.flashforge.com/10000/software/e02d016281d06012ea71a671d1e1fdb7.deb";
    hash = "sha256-6vBEthQD0HM2D+l+2dwWmdU+XPJpcvZQM+2GMuaf5Pw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt5.wrapQtAppsHook
    dpkg
  ];

  buildInputs = [
    libGLU
    libGL
    udev
    glibc
    qt5.qtbase
  ];

  unpackPhase = "true";

  buildPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    mkdir --parent $out/bin
    cp --recursive usr $out/
    cp --recursive etc $out/
    ln --symbolic $out/usr/share/FlashPrint5/FlashPrint $out/bin/FlashPrint
    sed -i "/^Exec=/ c Exec=$out/bin/FlashPrint" $out/usr/share/applications/FlashPrint5.desktop
  '';
}
