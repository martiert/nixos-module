{ stdenvNoCC, pkgs, lib, fetchFromGitHub }:

let
  x13s-alarm-firmware = stdenvNoCC.mkDerivation rec {
    pname = "x13s-alarm-firmware";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "ironrobin";
      repo = "x13s-alarm";
      rev = "efa51c3b519f75b3983aef67855b1561d9828771";
      sha256 = "sha256-weETbWXz9aL2pDQDKk7fkb1ecQH0qrhUYDs2E5EiJcI=";
    };

    dontFixup = true;
    dontBuild = true;

    installPhase = ''
      for i in a690_gmu.bin   hpnv21.b8c  qcvss8280.mbn 
      do
        install -D -m644 x13s-firmware/$i $out/$i
      done
    '';
  };

in {
  linux-firmware-modified = stdenvNoCC.mkDerivation rec {
    pname = "linux-firmware-modified";
    version = pkgs.linux-firmware.version;

    dontFixup = true;
    dontBuild = true;

    src = pkgs.linux-firmware;

    installPhase = ''
      mkdir $out
      cp -Pr lib $out/lib

      # Video acceleration
      cp ${x13s-alarm-firmware}/qcvss8280.mbn $out/lib/firmware/qcom/sc8280xp/LENOVO/21BX

      # Install bluetooth firmware for X13s
      cp ${x13s-alarm-firmware}/hpnv21.b8c $out/lib/firmware/qca

      # Install gpu firmware for X13s
      cp ${x13s-alarm-firmware}/a690_gmu.bin $out/lib/firmware/qcom
    '';
  };
}
