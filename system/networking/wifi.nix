let
  mkWifiConfig =
    { ssid, psk }:
    {
      ssid = {
        connection = {
          id = ssid;
          type = "wifi";
          autoconnect = true;
        };
        wifi = {
          mode = "infrastructure";
          ssid = ssid;
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = psk;
        };
      };
    };
  mkWifiConfigs = networks: builtins.foldl' (acc: net: acc // mkWifiConfig net) { } networks;
in
mkWifiConfigs [
  # { ssid = "<SSID>"; psk = "<PASSWORD>" }
]
