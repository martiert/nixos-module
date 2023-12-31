{ pkgs, lib, config, ... }:

let
  martiert = config.martiert;
  dtbName = "sc8280xp-lenovo-thinkpad-x13s.dtb";
  firmware = pkgs.callPackages ./firmware {};
in {
  imports = [
    ./services
  ];

  config = lib.mkIf (martiert.system.aarch64.arch == "sc8280xp") {
    boot = {
      kernelPackages = pkgs.callPackage ./kernel {};
      kernelParams = [
        "efi=novamap,noruntime"
        "pd_ignore_unused"
        "clk_ignore_unused"
        "loglevel=3"
      ];
      loader.grub = {
        extraFiles = {
          "sc8280xp-lenovo-thinkpad-x13s.dtb" = "${config.boot.kernelPackages.kernel}/dtbs/qcom/sc8280xp-lenovo-thinkpad-x13s.dtb";
        };
        extraConfig = ''
          terminal_input console
          terminal_output gfxterm
        '';
      };
    };
    hardware = {
      deviceTree.enable = true;
      enableAllFirmware = false;
      enableRedistributableFirmware = false;
      firmware = [
        firmware.linux-firmware-modified
      ];
      bluetooth.enable = true;
    };

    environment.systemPackages = [
      pkgs.alsa-ucm-conf
    ];

    martiert = {
      boot = {
        initrd = {
          kernelModules = [
            "nvme"
            "phy_qcom_qmp_pcie"
            "pcie_qcom"
            "i2c_hid_of"
            "i2c_qcom_geni"
            "leds_qcom_lpg"
            "pwm_bl"
            "qrtr"
            "pmic_glink_altmode"
            "gpio_sbu_mux"
            "phy_qcom_qmp_combo"
            "panel-edp"
            "msm"
            "phy_qcom_edp"
          ];
        };
        kernelModules = [];
      };
    };
  };
}
