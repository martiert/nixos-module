{ linuxPackagesFor, linuxPackages_latest, lib, ... }:

linuxPackagesFor (linuxPackages_latest.kernel.override {
  structuredExtraConfig = with lib.kernel; {
    TYPEC = yes;
    PHY_QCOM_QMP = yes;
    QCOM_CLK_RPM = yes;
    MFD_QCOM_RPM = yes;
    REGULATOR_QCOM_RPM = yes;
    PHY_QCOM_QMP_PCIE = yes;
    CLK_X1E80100_CAMCC = yes;
  };
})
