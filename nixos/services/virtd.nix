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
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };

  environment.systemPackages = [
    pkgs.virt-manager
  ];

  environment.etc.OVMF.source = SecureOVMF;
  boot.kernelParams = [ "intel_iommu=on" ];
}
