{ lib, writeShellScriptBin, stdenv, openssl, cacert, zlib, icu, dpkg, patchelf, fetchurl, ... }:

stdenv.mkDerivation rec {
  pname = "duo-desktop";
  version = "2.0.0";

  src = fetchurl {
    url = "https://desktop.pkg.duosecurity.com/duo-desktop-latest.amd64.deb";
    hash = "sha256-0H7VM6Z8Ijlj6CaNs+cgRKTsEbhaW+UdBKp24ymvUT0=";
  };

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;
  sourceRoot = ".";
  preferLocalBuild = true;

  libPath = lib.makeLibraryPath nativeBuildInputs;

  nativeBuildInputs = [
    stdenv.cc.cc.lib
    openssl
    cacert
    patchelf
    zlib
    icu
    dpkg
  ];
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/opt/duo/duo-desktop/duo-desktop
    mkdir $out/bin
    ln -s $out/opt/duo/duo-desktop/duo-desktop $out/bin/


  '';
}
