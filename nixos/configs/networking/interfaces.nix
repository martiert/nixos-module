{ lib, config, ...}:

let
  interfaces = config.martiert.networking.interfaces;
  enabled_interfaces = lib.filterAttrs (_: value: value.enable) interfaces;

  supplicantConfig = iface: values: {
    configFile = {
      path = config.martiert.networking.interfaces."${iface}".supplicant.configFile;
    };
    userControlled.enable = !values.supplicant.wired;
    extraConf = if values.supplicant.wired then "" else ''
      ap_scan=1
      p2p_disabled=1
    '';
    driver = if values.supplicant.wired then "wired" else "nl80211,wext";
  };
  supplicant_interfaces = lib.filterAttrs (_: value: value.supplicant.enable) enabled_interfaces;
  supplicant_config = builtins.mapAttrs supplicantConfig supplicant_interfaces;

  ifaceConfig = iface: value: {
    useDHCP = if (builtins.hasAttr "useDHCP" value) then value.useDHCP else false;
    ipv4.routes = lib.mkIf value.staticRoutes [
      { address = "3.214.5.205";      prefixLength = 32;  }
      { address = "10.0.0.0";         prefixLength = 8;  }
      { address = "148.62.0.0";       prefixLength = 16; }
      { address = "149.96.17.138";    prefixLength = 32; }
      { address = "144.254.0.0";       prefixLength = 16; }
      { address = "171.68.0.0";       prefixLength = 16; }
      { address = "171.70.0.0";       prefixLength = 16; }
      { address = "171.71.0.0";       prefixLength = 16; }
      { address = "173.36.0.0";       prefixLength = 16; }
      { address = "173.37.0.0";       prefixLength = 16; }
      { address = "173.38.0.0";       prefixLength = 16; }
      { address = "20.190.128.0";     prefixLength = 18; }
      { address = "20.190.129.0";     prefixLength = 24; }
      { address = "34.228.2.146";     prefixLength = 32; }
      { address = "40.126.0.0";       prefixLength = 18; }
      { address = "40.126.1.0";       prefixLength = 24; }
      { address = "44.207.157.89";    prefixLength = 24; }
      { address = "52.86.46.73";      prefixLength = 32; }
      { address = "54.86.167.119";    prefixLength = 32; }
      { address = "54.86.32.8";       prefixLength = 32; }
      { address = "64.101.0.0";       prefixLength = 16; }
      { address = "64.102.0.0";       prefixLength = 16; }
      { address = "64.103.0.0";       prefixLength = 16; }
      { address = "72.163.0.0";       prefixLength = 16; }
      { address = "64.100.37.70";     prefixLength = 32; }
      { address = "12.19.88.90";      prefixLength = 32;  }
    ];
    ipv6.routes = lib.mkIf value.staticRoutes [
      { address = "2001:420:464d::";    prefixLength = 48; }
      { address = "2603:1006:2000::";   prefixLength = 48; }
      { address = "2603:1007:200::";    prefixLength = 48; }
      { address = "2603:1016:1400::";   prefixLength = 48; }
      { address = "2603:1017::";        prefixLength = 48; }
      { address = "2603:1026:3000::";   prefixLength = 48; }
      { address = "2603:1027:1::";      prefixLength = 48; }
      { address = "2603:1036:3000::";   prefixLength = 48; }
      { address = "2603:1037:1::";      prefixLength = 48; }
      { address = "2603:1046:2000::";   prefixLength = 48; }
      { address = "2603:1047:1::";      prefixLength = 48; }
      { address = "2603:1056:2000::";   prefixLength = 48; }
      { address = "2603:1057:2::";      prefixLength = 48; }
    ];
  };
  interface_config = builtins.mapAttrs ifaceConfig enabled_interfaces;

  disableDHCPGatewayFor = iface: _: ''
    interface ${iface}
    nogateway'';
  static_routed_interfaces = lib.filterAttrs (_: value: value.staticRoutes) enabled_interfaces;
  disabledDHCPGateways = lib.concatStrings (lib.mapAttrsToList disableDHCPGatewayFor static_routed_interfaces);

  globalDHCPConfig = if config.martiert.networking.dhcpcd.leaveResolveConf then
    "nohook resolv.conf" else "";

  extraDHCPConfig = lib.concatStringsSep "\n" [
    globalDHCPConfig
    disabledDHCPGateways
  ];

  makeBridge = _: value: {
    interfaces = value.bridgedInterfaces;
  };
  bridgeConfig = builtins.mapAttrs makeBridge (lib.filterAttrs (_: value: value.bridgedInterfaces != []) enabled_interfaces);
in {
  networking.useDHCP = false;
  networking.interfaces = interface_config;
  networking.supplicant = supplicant_config;

  networking.dhcpcd.extraConfig = extraDHCPConfig;
  networking.bridges = bridgeConfig;
}
