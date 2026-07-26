{ nixpkgs-unstable, pkgs-unstable, ... }:
{
  imports = [
    {
      nixpkgs.overlays = [
        (final: prev: {
          # Use specialArgs pkgs-unstable so HA picks up the same overlays
          # (e.g. paho-mqtt doCheck = false) as custom components.
          inherit (pkgs-unstable) home-assistant;
        })
      ];

      disabledModules = [
        "services/home-automation/home-assistant.nix"
      ];
    }
    "${nixpkgs-unstable}/nixos/modules/services/home-automation/home-assistant.nix"
  ];
}
