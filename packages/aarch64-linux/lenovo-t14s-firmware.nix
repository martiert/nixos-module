{ stdenv, fetchurl, innoextract, ... }:

stdenv.mkDerivation {
  name = "lenovo-t14s-firmware";
  version = "1.0.0";

  src = fetchurl {
    url = "https://download.lenovo.com/pccbbs/mobiles/n42qq11w.exe";
    hash = "sha256-RKBx82SQCwUTAPix/j3hSIyC8E+FUIkIktBF6dTD1s4=";
  };

  nativeBuildInputs = [ innoextract ]; 

  unpackPhase = ''
    mkdir -p app
    innoextract -d app "$src"
  '';

  installPhase = ''
    mkdir -p $out/lib/firmware/qcom/x1e80100/LENOVO/21N1

    fw_files="adsp_dtbs.elf
    adspr.jsn
    adsps.jsn
    adspua.jsn
    battmgr.jsn
    cdsp_dtbs.elf
    cdspr.jsn
    qcadsp8380.mbn
    qccdsp8380.mbn
    qcdxkmsuc8380.mbn"

    for file in $fw_files; do
      echo "FILE: $file"
      fw_path=$(find app -type f -name "$file" -print -quit)
      echo "FW_PATH: $fw_path"
      cp "$fw_path" "$out/lib/firmware/qcom/x1e80100/LENOVO/21N1/"
    done
  '';
}
