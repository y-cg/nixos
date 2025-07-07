{
  config,
  pkgs,
  inputs,
  ...
}:
let
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      "homekit_controller"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
    ];
    customComponents = [
      (
        with pkgs-unstable.python313Packages;
        pkgs-unstable.python313Packages.callPackage ./ha-xiaomi-home.nix {
          inherit construct;
          inherit paho-mqtt;
          inherit numpy;
          inherit cryptography;
          inherit psutil;
        }
      )
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
    };
  };
  networking.firewall.allowedTCPPorts = [
    8123
  ];
}
