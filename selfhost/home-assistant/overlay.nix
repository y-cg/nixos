{ nixpkgs-unstable, ... }:
{
  imports = [
    {
      nixpkgs.overlays = [
        (final: prev: {
          inherit (nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}) home-assistant;
        })
      ];

      disabledModules = [
        "services/home-automation/home-assistant.nix"
      ];
    }
    "${nixpkgs-unstable}/nixos/modules/services/home-automation/home-assistant.nix"
  ];
}
