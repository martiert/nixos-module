{ lib, configs, ... }:

with lib;

{
  options = {
    martiert = {
      system = {
        type = mkOption {
          type = types.enum [ "server" "desktop" "laptop" ];
          description = "What type of system are we building?";
        };
        gpu = mkOption {
          type = types.nullOr (types.enum [ "amd" "nvidia" "intel" ]);
          default = null;
          description = "GPU to use for this device";
        };
        aarch64 = {
          arch = mkOption {
            type = types.nullOr (types.enum [ "rpi3" "sc8280xp" ]);
            default = null;
            description = "AArch64 architecture";
          };
        };
      };
      hardware.nvidia = {
        openDriver = lib.mkEnableOption "Enable using the open nvidia driver";
      };
      boot = {
        efi.removable = mkOption {
          type = types.bool;
          default = false;
          description = "Install boot loader as removable";
        };
        initrd = {
          extraAvailableKernelModules = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Extra kernel module to make available";
          };
          kernelModules = mkOption {
            type = types.listOf types.str;
            default = [ "uas" "usbcore" "usb_storage" "ext4" "nls_cp437" "nls_iso8859_1" ];
            description = "Kernel modules to load as default for initrd";
          };
        };
        kernelModules = mkOption {
          type = types.listOf types.str;
          default = [ "kvm-intel" ];
          description = "Default kernel modules";
        };
      };
      mountpoints = {
        root = mkOption {
          default = null;
          type = types.nullOr (types.submodule {
            options = {
              encryptedDevice = mkOption {
                type = types.str;
                description = "device to unlock";
              };
              useFido2Device = mkEnableOption "Use a fido2 device to unlock the disk";
              useTpm2Device = mkEnableOption "Use a tpm2 to unlock the disk";
            };
          });
        };
        boot = mkOption {
          type = types.nullOr types.str;
          description = "device to mount to /boot";
          default = null;
        };
        swap = mkOption {
          type = types.nullOr types.str;
          description = "swap device to mount";
          default = null;
        };
      };
      sshd = {
        enable = mkEnableOption "Enable sshd";
        authorizedKeyFiles = mkOption {
          type = types.listOf types.path;
          default = [];
          description = "List of files to add to users authorized keys";
        };
      };
      dnsproxy.enable = mkEnableOption "Proxy dns requests through a local dns server";
      citrix.enable = mkEnableOption "Enable citrix workspace";
    };
  };

  imports = [
    ./xorg.nix
    ./networking
    ./home-manager
    ./dnssetup.nix
  ];
}
