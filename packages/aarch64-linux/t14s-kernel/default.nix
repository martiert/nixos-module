{ linuxPackages_latest, lib, ... }:

linuxPackages_latest.kernel.override {
  structuredExtraConfig = with lib.kernel; {
    CLK_X1E80100_CAMCC = yes;
    INTERCONNECT_QCOM = yes;

    MFD_QCOM_RPM = yes;
    MFD_SPMI_PMIC = yes;

    PHY_QCOM_QMP = yes;
    PHY_QCOM_QMP_PCIE = yes;

    QCOM_CLK_RPM = yes;
    QCOM_COMMAND_DB = yes;
    QCOM_RPMH = yes;
    QCOM_RPMHPD = yes;

    REGULATOR = yes;
    REGULATOR_FIXED_VOLTAGE = yes;
    REGULATOR_QCOM_RPM = yes;
    REGULATOR_QCOM_RPMH = yes;

    SPMI = yes;
    TYPEC = yes;
  };
}
