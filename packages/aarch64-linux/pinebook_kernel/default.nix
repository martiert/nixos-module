{ fetchgit, linuxKernel, lib, ... }:

let
  patches = [
"1001-arm64-dts-allwinner-add-ohci-ehci-to-h5-nanopi.patch"
"1002-gpu-drm-add-new-display-resolution-2560x1440.patch"
"1003-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch"
"1004-arm64-dts-rockchip-Add-Firefly-Station-p1-support.patch"
"1005-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch"
"1006-arm64-dts-amlogic-add-meson-g12b-ugoos-am6-plus.patch"
"1007-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-RockPr.patch"
"1009-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-Rock-P.patch"
"1010-ASOC-sun9i-hdmi-audio-Initial-implementation.patch"
"1011-arm64-dts-allwinner-h6-Add-hdmi-sound-card.patch"
"1012-arm64-dts-allwinner-h6-Enable-hdmi-sound-card-on-boards.patch"
"1013-arm64-dts-allwinner-add-OrangePi-3-LTS.patch"
"1014-Add-support-for-the-Hardkernel-ODROID-M1-board.patch"
"1015-arm64-dts-rockchip-add-rk3568-station-p2.patch"
"1016-arm64-dts-meson-radxa-zero-add-support-for-the-usb-t.patch"
"1017-arm64-dts-rockchip-add-OrangePi-4-LTS.patch"
"1018-Add-YT8531C-phy-support.patch"
"2001-staging-add-rtl8723cs-driver.patch"
"2003-arm64-dts-rockchip-Work-around-daughterboard-issues.patch"
"2004-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices.patch"
"3001-irqchip-gic-v3-add-hackaround-for-rk3568-its.patch"
"3003-arm64-dts-rockchip-Add-hdmi-cec-assigned-clocks-to-r.patch"
"3005-arm64-dts-rockchip-Add-Quartz64-B-eeprom.patch"
"3006-Misc-SOQuartz-Enablement.patch"
"3007-arm64-dts-rockchip-Enable-pcie2-and-audio-jack-on-rk3566-roc-pc.patch"
"3008-drm-panel-simple-Add-init-sequence-support.patch"
"3009-arm64-dts-rockchip-Move-Quartz64-A-to-mdio-setup.patch"
"3010-arm64-dts-rockchip-Add-Quartz64-A-battery-node.patch"
"3011-board-rock3a-gmac1.patch"
"4001-arm64-dts-rk3399-pinebook-pro-Fix-USB-PD-charging.patch"
"4002-arm64-dts-rk3399-pinebook-pro-Improve-Type-C-support-on-Pinebook-Pro.patch"
"4003-arm64-dts-rk3399-pinebook-pro-Remove-redundant-pinctrl-properties-from-edp.patch"
"4004-arm64-dts-rk3399-pinebook-pro-Remove-unused-features.patch"
"4005-arm64-dts-rk3399-pinebook-pro-Dont-allow-usb2-phy-driver-to-update-USB-role.patch"
"4006-arm64-dts-rockchip-rk3399-pinebook-pro-Support-both-Type-C-plug-orientations.patch"
"4007-ASoC-codec-es8316-DAC-Soft-Ramp-Rate-is-just-a-2-bit-control.patch"
"4008-arm64-dts-rk3399-pinebook-pro-Fix-codec-frequency-after-boot.patch"
"4009-arm64-dts-rockchip-rk3399-pinebook-pro-Fix-VDO-display-output.patch"
  ];

  manjaro-patches = fetchgit {
    url = "https://gitlab.manjaro.org/manjaro-arm/packages/core/linux.git";
    rev = "0ed13f5680a9f0b69949862bd828caf5d4c19f40";
    hash = "sha256-fg+1SsO1NOO/d4C49pTXAMuvps2axt9HHk8qGr7zHP8=";
  };

  create-patch = p: {
    name = p;
    patch = "${manjaro-patches}/${p}";
  };
in
  linuxKernel.kernels.linux_6_1.override {
    argsOverride = rec {
      kernelPatches = map create-patch patches;
    };
  }
