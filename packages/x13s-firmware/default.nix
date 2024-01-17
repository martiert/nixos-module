{ stdenvNoCC, lib, linux-firmware, fetchFromGitHub }:

let
  x13s-alarm-firmware = stdenvNoCC.mkDerivation rec {
    pname = "x13s-alarm-firmware";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "ironrobin";
      repo = "x13s-alarm";
      rev = "4e61f65b6033a20d50f0fbd3642f383c1a3d75a5";
      hash = "sha256-oKEbfBu40KYSr5w5qsTqeuTkRtPxnj0JWy4mrGCjxRU=";
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
in stdenvNoCC.mkDerivation rec {
  pname = "linux-firmware-modified";
  version = linux-firmware.version;

  dontFixup = true;
  dontBuild = true;

  src = linux-firmware;

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
}
