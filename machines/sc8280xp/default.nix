{ pkgs, lib, config, ... }:

let
  martiert = config.martiert;
  dtbName = "sc8280xp-lenovo-thinkpad-x13s.dtb";
in {
  imports = [
    ./services
  ];

  config = lib.mkIf (martiert.system.aarch64.arch == "sc8280xp") {
    boot = {
      kernelParams = [
        "clk_ignore_unused"
        "pd_ignore_unused"
        "arm64.nopauth"
        "efi=noruntime"
      ];
      loader.grub = {
        extraFiles = {
          dtbName = "${config.boot.kernelPackages.kernel}/dtbs/qcom/${dtbName}";
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
            "phy_qcom_qmp_usb"
            "hid_multitouch"
            "i2c_hid_of"
            "i2c_qcom_geni"
            "leds_qcom_lpg"
            "pwm_bl"
            "qrtr"
            "pmic_glink_altmode"
            "gpio_sbu_mux"
            "phy_qcom_qmp_combo"
            "gpucc_sc8280xp"
            "dispcc_sc8280xp"
            "phy_qcom_edp"
            "panel_edp"
            "msm"
          ];
        };
        kernelModules = [];
      };
    };
  };
}
