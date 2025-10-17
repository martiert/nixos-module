{ pkgs, lib, config, ... }:

let
  martiert = config.martiert;
  SecureOVMF = pkgs.stdenv.mkDerivation {
    pname = "SecureOVMF";
    version = "1.0.0";

    src = ./OVMF;

    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
  };
in lib.mkIf martiert.virtd.enable {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  environment.systemPackages = [
    pkgs.virt-manager
  ];

  environment.etc."OVMF/OVMF_CODE.cc.fd" = {
    source = "${SecureOVMF}/OVMF_CODE.cc.fd";
    mode = "0660";
  };
  environment.etc."OVMF/OVMF_CODE.secboot.fd" = {
    source = "${SecureOVMF}/OVMF_CODE.secboot.fd";
    mode = "0660";
  };
  environment.etc."OVMF/OVMF_VARS.fd" = {
    source = "${SecureOVMF}/OVMF_VARS.fd";
    mode = "0660";
  };
  environment.etc."OVMF/OVMF_VARS.secboot.fd" = {
    source = "${SecureOVMF}/OVMF_VARS.secboot.fd";
    mode = "0660";
  };
  environment.etc."OVMF/Shell.efi" = {
    source = "${SecureOVMF}/Shell.efi";
    mode = "0660";
  };
  environment.etc."OVMF/UefiShell.iso" = {
    source = "${SecureOVMF}/UefiShell.iso";
    mode = "0660";
  };
  environment.etc."OVMF/EnrollDefaultKeys.efi" = {
    source = "${SecureOVMF}/EnrollDefaultKeys.efi";
    mode = "0660";
  };

  boot.kernelParams = [ "intel_iommu=on" ];
}
